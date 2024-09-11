#!/usr/bin/env bash
sudo nixos-rebuild switch \
  --show-trace \
  --fast \
  --accept-flake-config \
  --flake .#$(hostname)
