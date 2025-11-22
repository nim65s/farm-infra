{
  modulesPath,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/qemu-vm.nix" # if you want to run this in qemu
    ../common.nix
    ../farm-infra-web.nix
  ];

  networking.hostName = "farm-infra-server";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.farm-infra-web.enable = true;

  # For the demo only: start this system in a VM
  # For real hardware, you can remove this, and add disk configuration and hardware infos instead
  # ref. https://wiki.nixos.org/wiki/Nixos-generate-config (this is a part of the NixOS .iso install medium)
  # also ref. https://github.com/nix-community/disko for fancy disk config
  services.qemuGuest.enable = true;
  virtualisation = {
    cores = 2;
    memorySize = 8182;
    diskSize = 8192;
    graphics = true;
    qemu.options = [
      "-device"
      "virtio-vga"
    ];
    spiceUSBRedirection.enable = true;
    forwardPorts = [
      {
        from = "host";
        host.port = 2222;
        guest.port = 22;
      }
      {
        from = "host";
        host.port = 8000;
        guest.port = 80;
      }
    ];
  };
}
