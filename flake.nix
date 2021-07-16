{
  description = "Yuki's configuration for Nix systems";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.astolfo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./secrets/astolfo.nix
      ];
    };
  };
}
