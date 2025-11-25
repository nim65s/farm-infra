{
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles.azvfp = {
    connection = {
      id = "azvfp";
      type = "wifi";
      autoconnect = true;
    };
    ipv4 = {
      method = "manual";
      dhcp = "yes";
      addresses = [
        {
          address = "192.168.3.14";
          prefix = 24;
        }
      ];
    };
    wifi = {
      mode = "infrastructure";
      ssid = "azvfp";
    };
    wifi-security = {
      key-mgmt = "wpa-psk";
      # Yes, this is a cleartext password that I do use for this demo.
      # A better solution is to encrypt that in a way the host can decrypt at runtime:
      # https://github.com/nim65s/dotfiles/blob/main/vars/shared/wifi.azv/password/secret
      psk = "azvfp4tw";
    };
  };
}
