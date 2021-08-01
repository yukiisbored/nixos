{ config, pkgs, lib, ... }:
{
  imports = [
    ./modules/core.nix
    ./modules/live.nix
  ];
}
