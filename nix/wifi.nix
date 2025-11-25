{
  pkgs,
  ...
}:
{
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles.azvfp = {
    connection = {
      id = "azvfp";
      type = "wifi";
      autoconnect = true;
    };
    wifi = {
      mode = "infrastructure";
      ssid = "azvfp";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      # Yes, this is a cleartext password that I do use for this demo.
      # A better solution is to encrypt that in a way the host can decrypt at runtime, eg:
      # https://github.com/nim65s/dotfiles/blob/main/vars/shared/wifi.azv/password/secret
      psk = "azvfp4tw";
    };
  };

  # because it's 2025 and I still have no idea how to tell NetworkManager
  # I want both the dhcp and a static ipv4…
  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeShellScript "nm-azvfp-static-ip" ''
        if [ "$2" = "up" ] && [ "$CONNECTION_ID" = "azvfp" ]; then
          logger "NM dispatcher: adding 192.168.3.14/24 to wlan0"
          ip addr add 192.168.3.14/24 dev "$DEVICE_IFACE" || true
        fi
      '';
    }
  ];
}
