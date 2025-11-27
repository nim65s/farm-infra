{
  config,
  pkgs,
  ...
}:

let
  svelteApp = pkgs.callPackage ../frontend/package.nix { };
  backendApp = pkgs.python3Packages.callPackage ../backend/package.nix { };
  pythonEnv = pkgs.python3.withPackages (p: [
    backendApp
    p.gunicorn
    p.psycopg
  ]);
  name = "farm-infra-web";
  socket = "/run/${name}/gunicorn.sock";
  homeDir = "/srv/${name}";
  staticDir = "${homeDir}/static/";
in
{
  systemd.services."${name}" = {
    description = "Manage ${name}";
    wantedBy = [ "multi-user.target" ];
    wants = [ "postgresql.target" ];

    environment = {
      DJANGO_SETTINGS_MODULE = "backend.settings";
      FARM_INFRA_BACKEND_PRODUCTION = "1";
    };

    serviceConfig = {
      ExecStartPre = [
        "${pythonEnv}/bin/django-admin migrate"
        "${pythonEnv}/bin/django-admin collectstatic --no-input"
        "${pythonEnv}/bin/django-admin loaddata todo" # sample todos, remove this in prod :)
        "${pythonEnv}/bin/django-admin loaddata admin" # add admin:admin account. DON'T DO THIS IN PROD !
      ];
      ExecStart = "${pythonEnv}/bin/gunicorn -b unix:${socket} backend.wsgi";
      Restart = "always";
      User = name;
      Group = name;
      RuntimeDirectory = name;
      RuntimeDirectoryMode = "0750";
    };
  };

  users.groups."${name}" = { };
  users.users."${name}" = {
    isSystemUser = true;
    createHome = true;
    home = homeDir;
    homeMode = "0750";
    group = name;
    packages = [ pythonEnv ];
  };
  users.users.nginx.extraGroups = [ name ];

  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [ name ];
      ensureUsers = [
        {
          name = name;
          ensureDBOwnership = true;
          ensureClauses = {
            createdb = true;
            createrole = true;
          };
        }
      ];
    };
    nginx = {
      enable = true;
      virtualHosts.localhost = {
        default = true;
        locations =
          let
            grafanaHost = config.services.grafana.settings.server.http_addr;
            grafanaPort = config.services.grafana.settings.server.http_port;
            proxy = proxyPass: {
              proxyPass = proxyPass;
              extraConfig = ''
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection $connection_upgrade;

                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header X-Real-IP $remote_addr;
              '';
            };
            static = root: {
              root = root;
              extraConfig = ''
                autoindex off;
                expires 30d;
              '';
            };
          in
          {
            "/api" = proxy "http://unix:${socket}";
            "/backend" = proxy "http://unix:${socket}";
            "/static" = static staticDir;
            "/whoami" = proxy "http://localhost:8080";
            "/ws/salameche" = proxy "http://localhost:9001";
            "/ws/carapuce" = proxy "http://localhost:9002";
            "/ws/bulbizarre" = proxy "http://localhost:9003";
            "/alloy/" = proxy "http://localhost:12345/alloy/";
            "/grafana" = proxy "http://${grafanaHost}:${toString grafanaPort}";
            "/" = static svelteApp;
          };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [ 80 ];
}
