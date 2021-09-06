{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/all-hardware.nix")
    (modulesPath + "/installer/scan/detected.nix")
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
  ];

  boot.supportedFilesystems = [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "zfs" "ntfs" "cifs" ];

  networking = {
    hostName = "amnesiac";
    hostId = "ffffffff";
  };

  services.getty.autologinUser = "yuki";
  services.xserver.displayManager = {
    gdm = {
      autoSuspend = false;
    };

    autoLogin = {
      enable = true;
      user = "yuki";
    };
  };

  users.users = {
    root.initialHashedPassword = "";
    yuki.initialHashedPassword = "";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  environment.systemPackages = with pkgs; [
    testdisk
    ms-sys
    efibootmgr
    efivar
    parted
    gptfdisk
    ddrescue
    ccrypt
    cryptsetup
    mkpasswd

    sdparm
    hdparm
    smartmontools
    pciutils
    usbutils

    ntfsprogs
    dosfstools
    xfsprogs.bin
    jfsutils
    f2fs-tools

    tor-browser-bundle-bin
  ];

  system.extraDependencies = with pkgs; [
    stdenv
    stdenvNoCC
    busybox
    jq
  ];

  networking.wireguard.enable = true;

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
}
