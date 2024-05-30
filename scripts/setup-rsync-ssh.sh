#!/usr/bin/env bash
scp ~/.ssh/id_ed25519.pub $(cat ../hosts/nixos/common/optional/services/restic/url.txt):.ssh/authorized_keys
