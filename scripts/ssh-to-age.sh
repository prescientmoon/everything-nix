#!/usr/bin/env bash
echo "📁 Creating sops directory"
mkdir -p ~/.config/sops/age
echo "🔑 Converting ssh key to age"
nix-shell -p ssh-to-age --run "ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt"
echo "🚀 All done"
