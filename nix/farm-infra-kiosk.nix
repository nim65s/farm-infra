{
  config,
  pkgs,
  ...
}:
{
  users.users.kiosk = {
    isNormalUser = true;
    packages = [
      pkgs.cage
      pkgs.ungoogled-chromium
    ];
  };

  hardware.opengl.enable = true;
  services.xserver.enable = false;

  services.getty.autologinUser = "kiosk";
  programs.bash.loginShellInit = "exec cage -- chromium --kiosk http://web.farm:8000";

  fonts.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
  ];

  networking.hosts = {
    "192.168.8.106" = [ "web.farm" ];
  };

  # cage won't read services.xserver.xkb on its own :(
  environment.variables = {
    XKB_DEFAULT_LAYOUT = config.services.xserver.xkb.layout;
    XKB_DEFAULT_VARIANT = config.services.xserver.xkb.variant;
  };
}
