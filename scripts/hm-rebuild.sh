#!/run/current-system/sw/bin/bash
home-manager build --flake .#$1
rm -rf result ~/.local/share/hm-result/$1
mv result ~/.local/share/hm-result/$1
