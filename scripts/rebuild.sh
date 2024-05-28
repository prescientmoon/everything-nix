#!/usr/bin/env bash
sudo nixos-rebuild switch --flake .#$hostname --show-trace --fast
