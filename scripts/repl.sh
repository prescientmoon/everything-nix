#!/usr/bin/env bash
nix repl ".#nixosConfigurations.$1.config"
