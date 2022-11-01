{
  description = "Yuki's configuration for NixOS systems";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, utils, nixpkgs, impermanence }:
    {
      nixosConfigurations.usagiyama = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          impermanence.nixosModules.impermanence
          ./modules/core.nix
          ./secrets/usagiyama.nix
        ];
      };

      nixosConfigurations.astolfo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          impermanence.nixosModules.impermanence
          ./modules/core.nix
          ./secrets/astolfo.nix
        ];
      };
    };
}
