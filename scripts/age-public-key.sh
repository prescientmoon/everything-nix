#!/usr/bin/env bash
nix-shell -p age --run "age-keygen -y ~/.config/sops/age/keys.txt"
