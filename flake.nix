{
  description = "Farm Infra";

  inputs = {
    # up-to-date packages, built on a slightly less up-to-date nixpkgs
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    # the slightly less up-to-date nixpkgs for ROS packages, might be a few months old
    nixpkgs-ros.follows = "nix-ros-overlay/nixpkgs";
    # up-to-date nixpkgs, for a secure system
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
            modules = [ ./nix/server/configuration.nix ];
          };
          rpi = inputs.nixpkgs.lib.nixosSystem {
            modules = [ ./nix/rpi/configuration.nix ];
          };
          rpi-vm = inputs.nixpkgs.lib.nixosSystem {
            modules = [ ./nix/rpi-vm/configuration.nix ];
          };
        };
      };
      perSystem =
        { pkgs, ... }:
        {
          packages = {
            backend = pkgs.python3Packages.callPackage ./backend/package.nix { };
          };
        };
    };
}
