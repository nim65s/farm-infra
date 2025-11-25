# TODO
# Somehow find a stack that work…
# opensearch ? fluent-bit ? loki ? grafana ? promtail ? vector ?
{
  config,
  pkgs,
  ...
}:
{
  services = {
    fluent-bit = {
      enable = true;
      settings = {
        pipeline = {
          inputs = [
            {
              name = "systemd";
            }
          ];
          outputs = [
            {
              name = "loki";
              match = "host.*";
              host = "127.0.0.1";
              port = 3100;
              labels = "job=systemd,host=${config.networking.hostName}";
            }
          ];
        };
      };
    };
    loki = {
      enable = true;
      # copy/paste from https://grafana.com/docs/loki/latest/configure/examples/configuration-examples/#1-local-configuration-exampleyaml
      configuration = {
        "auth_enabled" = false;
        "server" = {
          "http_listen_port" = 3100;
        };
        "common" = {
          "ring" = {
            "instance_addr" = "127.0.0.1";
            "kvstore" = {
              "store" = "inmemory";
            };
          };
          "replication_factor" = 1;
          "path_prefix" = "/tmp/loki";
        };
        "schema_config" = {
          "configs" = [
            {
              "from" = "2020-05-15";
              "store" = "tsdb";
              "object_store" = "filesystem";
              "schema" = "v13";
              "index" = {
                "prefix" = "index_";
                "period" = "24h";
              };
            }
          ];
        };
        "storage_config" = {
          "filesystem" = {
            "directory" = "/tmp/loki/chunks";
          };
        };
      };
    };
    grafana = {
      enable = true;

      declarativePlugins = [
        pkgs.grafanaPlugins.grafana-opensearch-datasource
      ];
      settings.server = {
        root_url = "%(protocol)s://%(domain)s:%(http_port)s/grafana/";
        serve_from_sub_path = true;
      };
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Loki";
            type = "loki";
            access = "proxy";
            url = "http://127.0.0.1:3100";
            isDefault = true;
          }
        ];
      };
    };
  };
  systemd.services.vector.serviceConfig = {
    SupplementaryGroups = [ "systemd-journal" ];
  };
}
