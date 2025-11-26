{
  services.udev.extraRules = ''
    ENV{ID_VENDOR_ID}=="0eef", \
    ENV{ID_MODEL_ID}=="c002", \
    ENV{WL_INPUT}="DVI1", \
    ENV{LIBINPUT_CALIBRATION_MATRIX}="0 -1 1 1 0 0 0 0 1"
  '';
}
