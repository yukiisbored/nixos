{ config, pkgs, lib, ... }:

{
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };

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
      git stow ntfs3g
    ];

    shells = with pkgs; [
      bashInteractive zsh
    ];
  };

  users.users = {
    yuki = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "vboxusers" ];
      shell = pkgs.zsh;
    };
  };

  system.stateVersion = "21.05";
}
