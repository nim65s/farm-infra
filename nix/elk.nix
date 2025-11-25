{
  config,
  pkgs,
  ...
}:
let
  opensearchHost = config.services.opensearch.settings."network.host";
  opensearchPort = config.services.opensearch.settings."http.port";
  opensearchUrl = "http://${opensearchHost}:${toString opensearchPort}";
in
{
  services = {
    opensearch = {
      enable = true;
    };
    vector = {
      enable = true;
      settings = {
        sources.journald = {
          type = "journald";
        };
        sinks.opensearch = {
          type = "elasticsearch";
          inputs = [ "journald" ];
          opensearch_service_type = "managed";
          endpoints = [ opensearchUrl ];
          index = "logs-%Y-%m-%d";
          suppress_type_name = true;
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
            name = "OpenSearch";
            type = "grafana-opensearch-datasource";
            url = opensearchUrl;
            access = "proxy";
            jsonData = {
              timeField = "@timestamp";
              flavor = "opensearch";
              version = "2.19.2";
            };
          }
        ];
      };
    };
  };
  systemd.services.vector.serviceConfig = {
    SupplementaryGroups = [ "systemd-journal" ];
  };
}
