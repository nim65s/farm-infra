{
  config,
  lib,
  pkgs,
  ...
}:

let
  app = pkgs.python3Packages.callPackage ./package.nix { };
  pythonEnv = pkgs.python3.withPackages (p: [
    app
    p.gunicorn
    p.psycopg
  ]);
  name = "farm-infra-backend";
  socket = "/run/${name}/gunicorn.sock";
  home = "/srv/${name}";
  static = "${home}/static/";
  cfg = config.services."${name}";
in
{
  options.services."${name}" = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable ${app.meta.description} systemd service";
    };
    hostName = lib.mkOption {
      default = "backend.localhost";
      description = "nginx virtual host";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services."${name}" = {
      description = app.meta.description;
      wantedBy = [ "multi-user.target" ];
      wants = [ "postgresql.target" ];

      serviceConfig = {
        Environment = [
          "DJANGO_SETTINGS_MODULE=backend.settings"
          "FARM_INFRA_BACKEND_PRODUCTION=1"
        ];
        ExecStartPre = [
          "${pythonEnv}/bin/django-admin migrate"
          "${pythonEnv}/bin/django-admin collectstatic --no-input"
          "${pythonEnv}/bin/django-admin loaddata admin"
          "${pythonEnv}/bin/django-admin loaddata todo"
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
      home = home;
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

        virtualHosts."${cfg.hostName}" = {
          root = static;

          locations."/" = {
            proxyPass = "http://unix:${socket}";
            extraConfig = ''
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Real-IP $remote_addr;
            '';
          };

          locations."/static/" = {
            alias = static;
            extraConfig = ''
              autoindex off;
              expires 30d;
            '';
          };
        };
      };
    };
    networking.firewall.allowedTCPPorts = [ 80 ];
  };
}
