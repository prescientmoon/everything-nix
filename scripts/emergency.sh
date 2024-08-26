#!/usr/bin/env nix-shell
#!nix-shell ../devshells/bootstrap/shell.nix
#!nix-shell -i bash

# Check if at least one argument is provided
if [ "$#" != "2" ] && [ "$#" != "3" ]; then
    echo "Usage: $0 <host> <disko-mode> [action]"
    exit 1
fi

host=$1
mode=$2
action=$3

# Ensure correct first argument type
if [ "$mode" != "disko" ] && [ "$mode" != "mount" ]; then
    echo "Disko action must be either 'disko' or 'mount'"
    exit 1
fi

# Ensure correct second argument type
if [ "$#" != "2" ] && [ "$action" != "install" ] && [ "$action" != "enter" ]; then
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


if [ "$mode" = "mount" ] && [ "$host" = "lapetus" ]; then
  echo "Importing zpool"
  zpool import -lfR /mnt zroot
fi

echo "Running disko"
nix run disko -- --mode $MODE ./hosts/nixos/$host/filesystems/partitions.nix

if [ "$action" = "install" ]; then
  echo "Generating hardware config"
  nixos-generate-config --no-filesystems --show-hardware-config \
    > ./hosts/nixos/$host/hardware/generated.nix
  git add .

  echo "Installing nixos"
  nixos-install --flake ".#$host"
fi

if [ "$action" = "enter" ]; then
  echo "Entering nixos"
  nixos-enter --root /mnt
fi

echo "All done!"
