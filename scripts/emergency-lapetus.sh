echo "Entering shells..."
exec nix-shell ./devshells/bootstrap/shell.nix
exec nix shell disko
echo "Mounting keys"
sudo mkdir /hermes
sudo mount /dev/disk/by-uuid/7FE7-CA68 /hermes
echo "Importing zfs pool"
sudo zpool import -lfR /mnt zroot
echo "Mounting zfs filesystem"
sudo disko --mode mount ./hosts/nixos/lapetus/filesystems/partitions.nix
echo "All done!"
