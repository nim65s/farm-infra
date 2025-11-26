{
  description = "Farm Infra Example";

  inputs = {
    # up-to-date ROS noetic packages, built on a nixpkgs from 25.05
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/ros1-25.05";
    # handle to nixpkgs from above. That one is supported until 2026. After that please swtich to ROS 2 :)
    nixpkgs-ros.follows = "nix-ros-overlay/nixpkgs";
    # up-to-date rolling release nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # helper
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      flake = {
        nixosConfigurations = {
          server = inputs.nixpkgs.lib.nixosSystem {
            modules = [ ./server/configuration.nix ];
            specialArgs = { inherit inputs; };
          };
          rpi = inputs.nixpkgs.lib.nixosSystem {
            modules = [ ./rpi/configuration.nix ];
          };
        };
      };
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            packages = [
              # burn RPi sd card / usb stick
              pkgs.caligula

              # backend
              pkgs.uv

              # frontend
              pkgs.nodejs
              pkgs.yarn-berry
              pkgs.yarn-berry.yarn-berry-fetcher
            ];
          };
          packages = {
            backend = pkgs.python3Packages.callPackage ./backend/package.nix { };
            frontend = pkgs.callPackage ./frontend/package.nix { };
            pcan = pkgs.callPackage ./rpi/pcan-linux-driver.nix { };
          };
        };
    };
}
