#!/usr/bin/env bash
dir=/hermes/secrets/$(hostname)/
mkdir -p $dir
cp /persist/state/etc/ssh/ssh* $dir
cp /home/*/.ssh/id* $dir
touch $dir/disk.key

echo "💫 Don't forget to provide a disk encryption key!"
