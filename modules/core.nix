{ config, pkgs, lib, ... }:

{
  boot.kernelParams = [ "net.ifnames=0" ];

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  nix = {
    package = pkgs.nixUnstable;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    trustedUsers = [ "root" "@wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;
    jack.enable = true;
  };

  hardware = {
    pulseaudio.enable = false;
    logitech.wireless.enable = true;
  };

  services.xserver = {
    enable = true;

    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };

    layout = "us";
    xkbVariant = "altgr-intl";

    libinput.enable = true;
  };

  services.trezord.enable = true;

  environment = {
    systemPackages = with pkgs; [
      git stow ntfs3g unzip zip pciutils ncpamixer ltunify
    ];

    shells = with pkgs; [
      bashInteractive zsh
    ];
  };

  virtualisation.docker.enable = true;

  users = {
    mutableUsers = false;

    users = {
      yuki = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        shell = pkgs.zsh;
      };
    };
  };

  system.stateVersion = "22.05";
}
