#!/usr/bin/env nix-shell
#!nix-shell ../devshells/bootstrap/shell.nix
#!nix shell disko
#!nix-shell -i bash

# Check if at least one argument is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <disko-mode> [action]"
    exit 1
fi

# Ensure correct first argument type
if [ "$1" != "disko" ] && [ "$1" != "mount" ]; then
    echo "Disko action must be either 'disko' or 'mount'"
    exit 1
fi

# Ensure correct second argument type
if [ "$#" != "1" ] && [ "$2" != "install" ] && [ "$2" != "enter" ]; then
    echo "Action must either be empty, 'install' or 'enter'"
    exit 1
fi

echo "Mounting keys"
sudo mkdir /hermes
sudo mount /dev/disk/by-uuid/7FE7-CA68 /hermes

echo "Running disko"

if [ "$1" -eq "mount" ]; then
  sudo zpool import -lfR /mnt zroot
fi

sudo disko --mode $1 ./hosts/nixos/lapetus/filesystems/partitions.nix

if [ "$2" = "install" ]; then
  echo "Installing nixos"
  sudo nixos-install --flake ".#lapetus"
fi

if [ "$2" = "enter" ]; then
  echo "Entering nixos"
  sudo nixos-enter --root /mnt
fi

echo "All done!"
