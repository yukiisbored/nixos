{ config, pkgs, lib, ... }:
{
  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
  };

  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    virt-manager
  ];

  users.users.yuki.extraGroups = [ "docker" "libvirtd" ];
}
