{
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout = "fr";
    variant = "ergol"; # remove this line for AZERTY default
  };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFPWyZK9yJEyY7DqxN+A2h4+LccOoZGt2OdWEYvwzXzT nim@yupa"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINlKH10l4IazTlC2UC0HV44iw/p7w7ufxaOk7VLX9vTG nim@ashitaka"
    ];
  };

  programs = {
    vim.enable = true;
    git.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  system.autoUpgrade = {
    enable = true;
    flake = "github:nim65s/farm-infra";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    extra-substituters = [
      "https://ros.cachix.org"
    ];
    extra-trusted-public-keys = [
      "ros.cachix.org-1:dSyZxI8geDCJrwgvCOHDoAfOm5sV1wCPjBkKL+38Rvo="
    ];
  };

  # This define the initial version and meaning for all other config options.
  # Do **NOT** ever change it, once a system is deployed.
  system.stateVersion = "25.05";
}
