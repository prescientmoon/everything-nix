set allow-duplicate-recipes

import 'migadux/justfile'
import 'dns/config/justfile'

[private]
default:
  @just --list

hostname := `hostname`

# {{{ Nixos rebuilds
[doc("Wrapper around `nixos-rebuild`")]
[group("nix")]
nixos-rebuild action="switch" host=hostname:
  #!/usr/bin/env python3
  import subprocess

  host = "{{host}}"
  users = {
    'tethys': 'adrielus',
    'lapetus': 'root',
    'calypso': 'moon',
  }
  hosts = {
    'tethys': 'tethys',
    'lapetus': '192.168.10.1',
    'calypso': 'calypso',
  }

  args = [
    "nixos-rebuild",
    "{{action}}",
    "--show-trace",
    "--accept-flake-config",
    "--flake", 
    ".#{{host}}",
    "--no-reexec"
  ]

  if host == "{{hostname}}": 
    print("🧬 Switching nixos configuration (locally) for '{{BLUE + host + NORMAL}}'")
    args = [ "sudo", *args ]
  else:
    print("🧬 Switching nixos configuration (remotely) for '{{BLUE + host + NORMAL}}'")
    args += [
      "--target-host",
      f"{users[host]}@{hosts[host]}",
      "--sudo",
      "--ask-sudo-password"
    ]

  try:
    subprocess.run(args, check=True)
    print("🚀 All done!")
  except KeyboardInterrupt:
    print("🪓 Command cancelled")
# }}}
# {{{ Miscellaneous nix commands
[doc("Build the custom ISO provided by the flake")]
[group("nix")]
build-iso:
  nix build .#nixosConfigurations.iso.config.system.build.isoImage

[doc("Bumps most flake inputs (not including things that are meant to be somewhat \"pinned\")")]
[group("nix")]
bump-common:
  nix flake update --accept-flake-config  \
    nixpkgs \
    nixpkgs-unstable \
    nix-index-database \
    neovim-nightly-overlay \
    firefox-addons \
    base16-schemes \
    rose-pine-hyprcursor \
    darkmatter-grub-theme \
    home-manager \
    stylix
# }}}

# {{{ Age / sops related thingies
[doc("Save the user's SSH key as a key usable by sops")]
[group("secrets")]
ssh-to-age:
  @echo "📁 Creating sops directory" >&2
  mkdir -p ~/.config/sops/age

  @echo "🔑 Converting ssh key to age" >&2
  ssh-to-age -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt

[doc("Print the public age key used by sops on this machine")]
[group("secrets")]
age-public-key: ssh-to-age
  @echo "🔑 Printing public age key" >&2
  age-keygen -y ~/.config/sops/age/keys.txt

[doc("Rekey every secrets file in the repository")]
[group("secrets")]
sops-rekey:
  #!/usr/bin/env python3
  import glob
  import subprocess

  paths = glob.glob("./**/secrets.yaml", recursive=True)
  for file in paths:
    print(f"🔑 Rekeying {file}")
    subprocess.run(["sops", "updatekeys", "--yes", file], check=True)

  print(f"🚀 Successfully rekeyed {len(paths)} files!")

[doc("Export keys to the hermes USB device")]
[group("secrets")]
export-keys:
  #!/usr/bin/env bash
  set -euo pipefail # Fail on errors and whatnot

  dir=/hermes/secrets/{{hostname}}/
  mkdir -p $dir

  cp /persist/state/etc/ssh/ssh* $dir
  cp /home/*/.ssh/id* $dir

  # Perhaps I should ask this as a prompt instead?
  touch $dir/disk.key
  echo "💫 Don't forget to provide a disk encryption key!"
# }}}
# {{{ Rsync
# TODO: move this to some sort of oneshot service
[doc("Give every machine access to the restic backups")]
[group("secrets")]
update-rsync-keys:
  #!/usr/bin/env bash
  set -euo pipefail # Fail on errors and whatnot
  shopt -s nullglob # Make globs expand to [] if no match

  keys=(hosts/nixos/*/keys/*.pub)

  if [ "${#keys[@]}" -eq 0 ]; then
    echo "❌ No SSH public keys found. Exiting." >&2
    exit 1
  fi

  tmpfile=$(mktemp)
  url=$(cat hosts/nixos/common/services/restic/url.txt)

  echo "🔑 Copying ${#keys[@]} keys to $url"
  cat ${keys[@]} > $tmpfile
  scp $tmpfile $url:.ssh/authorized_keys

  rm -f $tmpfile
  echo "🚀 Successfully updated rsync.net SSH keys!"
# }}}
