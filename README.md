# Yuki's configuration for Nix systems

[![NixOS 21.05](https://img.shields.io/badge/NixOS-v21.05-blue.svg?style=flat-square&logo=NixOS&logoColor=white)](https://nixos.org)

This repository contains a Nix flake which define the tailored system
configuration for Nix-powered systems.

## Install

Assuming you have changed `flake.nix` to define your host and their
host-specific configurations, simply run the following:

```console
# nixos-rebuild switch --flake /path/to/yuki/flake
```
