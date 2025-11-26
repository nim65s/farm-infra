# TODO: Somehow find a fancy stack that work out of the box
# opensearch ? fluent-bit ? loki ? grafana ? promtail ? vector ?
{
  services.journald.gateway = {
    enable = true;
    system = true;
    merge = true;
  };
}
