{
  description = "Yuki's configuration for Nix systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, impermanence }: {
    nixosConfigurations.astolfo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        impermanence.nixosModules.impermanence
        ./modules/core.nix
        ./modules/gayming.nix
        ./secrets/astolfo.nix
      ];
    };
  };
}
