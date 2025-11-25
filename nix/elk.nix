{
  config,
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
          endpoints = [ opensearchUrl ];
        };
      };
    };
    grafana = {
      enable = true;
      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "OpenSearch";
            type = "elasticsearch";
            url = opensearchUrl;
            access = "proxy";
            jsonData.timeField = "@timestamp";
          }
        ];
      };
    };
  };
}
