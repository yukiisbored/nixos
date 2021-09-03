{
  description = "Yuki's configuration for Nix systems";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-21.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dot.url = "github:yukiisbored/dot";
    impermanence.url = "github:nix-community/impermanence";
    nixos-generators.url = "github:nix-community/nixos-generators";
    pbp = {
      url = "github:samueldr/wip-pinebook-pro";
      flake = false;
    };
  };

  outputs = { self, utils, nixpkgs, impermanence, nixos-generators, pbp, home-manager, dot }:
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

    nixosConfigurations.live = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./modules/core.nix
        ./modules/live.nix

        {
          nixpkgs.overlays = dot.overlays.x86_64-linux;
        }

        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.yuki = dot.homeConfigurations.x86_64-linux.desktop;
        }
      ];
    };

    # XXX: Broken
    nixosConfigurations.amnesiac = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        ./modules/core.nix
        ./secrets/amnesiac.nix

        (import "${pbp}/pinebook_pro.nix")

        ({ config, modulesPath, ... }:
          {
            imports = [ (modulesPath + "/installer/sd-card/sd-image.nix") ];

            # FIXME: Check if we need to have `crossSystem'.
            nixpkgs.crossSystem = {
              system = "aarch64-linux";
            };

            boot = {
              loader = {
                grub.enable = false;
                generic-extlinux-compatible.enable = true;
              };
              consoleLogLevel = 0;
              kernelParams = ["console=ttyS0,115200n8" "console=tty0"];
            };

            sdImage = {
              populateFirmwareCommands = "";
              populateRootCommands = ''
                mkdir -p ./files/boot
                ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
              '';
            };
          })
      ];
    };
  }
  //
  utils.lib.eachDefaultSystem (system:
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
