{
  pkgs,
  ...
}:
let
  lokiAddr = "127.0.0.1";
  lokiPort = 3100;
  lokiConfigFile = "loki.yaml";
in
{
  environment.etc = {
    # ref. https://grafana.com/docs/alloy/latest/tutorials/send-logs-to-loki/
    "alloy/config.alloy".text = ''
      local.file_match "local_files" {
        path_targets = [
          {"__path__" = "/var/log/nginx/*.log"},
          {"__path__" = "/srv/*/.ros/log/latest/*.log"},
        ]
        sync_period = "5s"
      }

      loki.source.file "log_scrape" {
        targets    = local.file_match.local_files.targets
        forward_to = [loki.write.grafana_loki.receiver]
        tail_from_end = true
      }

      loki.source.journal "journald"  {
        forward_to = [loki.write.grafana_loki.receiver]
      }

      loki.write "grafana_loki" {
        endpoint {
          url = "http://${lokiAddr}:${toString lokiPort}/loki/api/v1/push"
        }
      }
    '';

    # ref. https://grafana.com/docs/loki/latest/configure/examples/configuration-examples/#1-local-configuration-exampleyaml
    "${lokiConfigFile}".source = (pkgs.formats.yaml { }).generate "loki.yaml" {
      "auth_enabled" = false;
      "server" = {
        "http_listen_port" = lokiPort;
      };
      "common" = {
        "ring" = {
          "instance_addr" = lokiAddr;
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

  services = {
    alloy = {
      enable = true;
      extraFlags = [ "--server.http.ui-path-prefix=/alloy/" ];
    };
    loki = {
      enable = true;
      configFile = "/etc/${lokiConfigFile}";
    };
    grafana = {
      enable = true;
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
            url = "http://${lokiAddr}:${toString lokiPort}";
            isDefault = true;
          }
        ];
      };
    };
  };

  systemd.services.alloy.serviceConfig.SupplementaryGroups = [
    "nginx"
    "ros"
  ];
}
