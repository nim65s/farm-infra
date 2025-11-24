{
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles.azvfp = {
    connection.id = "azvfp";
    connection.type = "wifi";
    connection.autoconnect = true;
    wifi.mode = "infrastructure";
    wifi.ssid = "azvfp";
    wifi-security.key-mgmt = "wpa-psk";
    # Yes, this is a cleartext password that I do use for this demo.
    # A better solution is to encrypt that in a way the host can decrypt at runtime:
    # https://github.com/nim65s/dotfiles/blob/main/vars/shared/wifi.azv/password/secret
    wifi-security.psk = "azvfp4tw";
  };
}
