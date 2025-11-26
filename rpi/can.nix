{
  pkgs,
  ...
}:
let
  pcanDriver = pkgs.callPackage ./pcan-linux-driver.nix { };
in
{
  boot.extraModulePackages = [ pcanDriver ];
  boot.kernelModules = [ "pcan" ];
}
