#!/usr/bin/env nix-shell
#!nix-shell -p sops -i bash

# https://askubuntu.com/questions/1010707/how-to-enable-the-double-star-globstar-operator
# Enable the ** operator
shopt -s globstar

for file in ./**/secrets.yaml; do
  echo "🔑 Rekeying $file"
  sops updatekeys --yes $file
done

echo "🚀 All done!"
