{
  breakpointHook,
  lib,
  stdenv,
  fetchurl,
  linuxPackages,
  popt,
}:
let
  kernel = linuxPackages.kernel;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "peak-linux-driver";
  version = "8.20.0";

  src = fetchurl {
    url = "https://www.peak-system.com/quick/PCAN-Linux-Driver";
    name = "${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-7+ytupKU7cOLvhiTh3CNDDSyXXYh+/1CCNixKBH8JYA=";
  };

  makeFlags = [
    "KERNEL_LOCATION=${kernel.dev}/lib/modules/${kernel.version}/build"
    "NET=NETDEV_SUPPORT"
    "-Cdriver"
  ];

  buildInputs = [
    popt
  ];

  nativeBuildInputs = [ breakpointHook ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.version}/extra
    cp driver/pcan.ko $out/lib/modules/${kernel.version}/extra/
  '';

  meta = {
    description = "PEAK-System GmbH PCAN Linux driver";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
})
