#!/usr/bin/env bash
# Create tmp file
tmpfile=$(mktemp)
# Concat files
cat hosts/nixos/*/keys/id_*.pub > $tmpfile
# Copy concat result
scp $tmpfile $(cat hosts/nixos/common/optional/services/restic/url.txt):.ssh/authorized_keys
# Cleanup file
rm -rf $tmpfile
