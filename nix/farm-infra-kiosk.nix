{
  config,
  pkgs,
  ...
}:
let
  xkb = config.services.xserver.xkb;
in
{
  users.users.kiosk = {
    isNormalUser = true;
    linger = true;
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    packages = [
      pkgs.cage
      pkgs.ungoogled-chromium
    ];
  };

  hardware.graphics.enable = true;
  services.xserver.enable = false;

  services.getty.autologinUser = "kiosk";
  systemd.user.services.kiosk = {
    description = "Kiosk Session: chromium in cage";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.cage}/bin/cage -- chromium http://web.farm:8000";
      # cage won't read services.xserver.xkb on its own :(
      Environment = [
        "XKB_DEFAULT_LAYOUT=${xkb.layout}"
        "XKB_DEFAULT_VARIANT=${xkb.variant}"
      ];
    };
  };

  fonts.packages = [
    pkgs.noto-fonts
    pkgs.noto-fonts-color-emoji
  ];

  networking.hosts = {
    "192.168.3.10" = [ "web.farm" ];
  };
}
