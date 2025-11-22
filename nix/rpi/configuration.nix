{
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ../common.nix
  ];

  networking.hostName = "farm-infra-kiosk";
  nixpkgs.hostPlatform = "aarch64-linux";

  # For the demo only: set a static IPv4 so that I can ssh
  networking.interfaces.end0.ipv4.addresses = [
    {
      address = "192.168.3.14";
      prefixLength = 24;
    }
  ];
}
