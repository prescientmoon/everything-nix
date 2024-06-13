#!/usr/bin/env bash
sudo nixos-rebuild switch --flake .#$HOSTNAME --show-trace --fast
