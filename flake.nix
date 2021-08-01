{
  description = "Yuki's configuration for Nix systems";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    impermanence.url = "github:nix-community/impermanence";
    nixos-generators.url = "github:nix-community/nixos-generators";
  };

  outputs = { self, utils, nixpkgs, impermanence, nixos-generators }: {
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

    nixosConfigurations.live = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/core.nix
        ./modules/live.nix
      ];
    };
  } // utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixos-generators.defaultPackage.${system}
        ];
      };
    });
}
