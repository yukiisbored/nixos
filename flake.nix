{
  description = "Yuki's configuration for NixOS systems";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    impermanence.url = "github:nix-community/impermanence";
    hm = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot.url = "github:yukiisbored/dot";
  };

  outputs = { self, utils, nixpkgs, impermanence, hm, dot }:
    {
      nixosConfigurations.astolfo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          impermanence.nixosModules.impermanence
          ./modules/core.nix
          ./modules/gayming.nix
          ./modules/vm.nix
          ./secrets/astolfo.nix
        ];
      };

      nixosConfigurations.amnesiac = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/core.nix
          ./modules/amnesiac.nix

          {
            nixpkgs.overlays = dot.overlays.x86_64-linux;
          }

          hm.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.yuki = dot.homeConfigurations.x86_64-linux.desktop;
          }
        ];
      };
    }
}
