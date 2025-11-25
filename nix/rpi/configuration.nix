{
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ../common.nix
    ../farm-infra-kiosk.nix
    ../wifi.nix
  ];

  networking.hostName = "farm-infra-rpi";
  nixpkgs.hostPlatform = "aarch64-linux";

  # For the demo only: set a static IPv4 so that I can ssh
  networking.interfaces = {
    end0.ipv4.addresses = [
      {
        address = "192.168.2.14";
        prefixLength = 24;
      }
    ];
  };

  # debug tools
  programs = {
    trippy.enable = true;
  };
}
