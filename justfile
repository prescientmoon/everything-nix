[private]
default:
  @just --list

hostname := `hostname`

# {{{ Nixos rebuilds
[doc("Wrapper around `nixos-rebuild`, taking care of the generic arguments")]
[group("nix")]
nixos-rebuild action="switch" host=hostname:
  #!/usr/bin/env python3
  import subprocess

  host = "{{host}}"
  users = {
    'tethys': 'adrielus',
    'lapetus': 'adrielus',
    'calypso': 'moon',
  }

  args = [
    "nixos-rebuild",
    "{{action}}",
    "--show-trace",
    "--fast",
    "--accept-flake-config",
    "--flake", 
    ".#{{host}}"
  ]

  if "{{host}}" == "{{hostname}}": 
    print("🧬 Switching nixos configuration (locally) for '{{BLUE + host + NORMAL}}'")
    args = ["sudo", *args]
  else:
    print("🧬 Switching nixos configuration (remotely) for '{{BLUE + host + NORMAL}}'")
    args.append("--use-remote-sudo")
    args += ["--target-host", f"{users[host]}@{host}"]

  subprocess.run(args, check=True)
  print("🚀 All done!")
# }}}
# {{{ Miscellaneous nix commands
[doc("Build the custom ISO provided by the flake")]
[group("nix")]
build-iso:
  nix build .#nixosConfigurations.iso.config.system.build.isoImage

[doc("Bumps flake inputs that usually need to be as up to date as possible")]
[group("nix")]
bump-common:
  nix flake update \
    nixpkgs-unstable \
    neovim-nightly-overlay \
    firefox-addons \
    base16-schemes
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
  url=$(cat hosts/nixos/common/optional/services/restic/url.txt)

  echo "🔑 Copying ${#keys[@]} keys to $url"
  cat ${keys[@]} > $tmpfile
  scp $tmpfile $url:.ssh/authorized_keys

  rm -f $tmpfile
  echo "🚀 Successfully updated rsync.net SSH keys!"
# }}}

# {{{ DNS
[doc("Prints the differences between the current and desired DNS records")]
[group("dns")]
dns-diff:
  nix run .#octodns-sync --

[doc("Syncs DNS records using octodns")]
[group("dns")]
dns-push:
  nix run .#octodns-sync -- --doit

[doc("Clears every DNS record")]
[group("dns")]
dns-clear zoneid bearer:
  #!/usr/bin/env bash
  set -euo pipefail # Fail on errors and whatnot

  # Taken from https://developers.cloudflare.com/dns/zone-setups/troubleshooting/delete-all-records/
  curl --silent "https://api.cloudflare.com/client/v4/zones/{{zoneid}}/dns_records?per_page=50000" \
  --header "Authorization: Bearer {{bearer}}" \
  | jq --raw-output '.result[].id' | while read id
  do
    echo "🧹 Deleting '$id' record in zone '{{zoneid}}'"
    curl --silent --request DELETE "https://api.cloudflare.com/client/v4/zones/{{zoneid}}/dns_records/$id" \
  --header "Authorization: Bearer {{bearer}}"
  done

  echo "🚀 All done!"
# }}}
