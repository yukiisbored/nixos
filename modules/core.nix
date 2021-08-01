{ config, pkgs, lib, ... }:

{
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

  sound.enable = true;
  hardware = {
    pulseaudio.enable = true;
    opengl.driSupport32Bit = true;
  };

  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = false;
    };

    desktopManager.gnome.enable = true;

    layout = "us";
    xkbVariant = "altgr-intl";

    libinput.enable = true;
  };

  services.trezord.enable = true;

  environment = {
    systemPackages = with pkgs; [
      git stow ntfs3g unzip zip
    ];

    shells = with pkgs; [
      bashInteractive zsh
    ];
  };


  users = {
    mutableUsers = false;

    users = {
      yuki = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        shell = pkgs.zsh;
      };
    };
  };

  system.stateVersion = "21.05";
}
