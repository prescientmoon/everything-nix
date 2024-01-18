#!/usr/bin/env nix-shell
#!nix-shell ../devshells/bootstrap/shell.nix
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

if mountpoint -q /hermes; then 
  echo "Keys already mounted"
else
  echo "Mounting keys"
  mkdir -p /hermes
  mount /dev/disk/by-uuid/7FE7-CA68 /hermes
fi

echo "Running disko"

if [ "$1" = "mount" ]; then
  zpool import -lfR /mnt zroot
fi

nix run disko -- --mode $1 ./hosts/nixos/lapetus/filesystems/partitions.nix

if [ "$2" = "install" ]; then
  echo "Installing nixos"
  nixos-install --flake ".#lapetus"
fi

if [ "$2" = "enter" ]; then
  echo "Entering nixos"
  nixos-enter --root /mnt
fi

echo "All done!"
