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

  # This define the initial version and meaning for all other config options.
  # Do **NOT** ever change it, once a system is deployed.
  system.stateVersion = "25.05";
}
