#!/usr/bin/env bash
nix build .#nixosConfigurations.iso.config.system.build.isoImage
