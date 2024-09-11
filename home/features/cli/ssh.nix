{ pkgs, lib, ... }:
{
  programs.ssh.enable = true;
  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];

  # This allows me to push/pull to my forgejo server via SSH.
  # See the docs for more details: https://developers.cloudflare.com/cloudflare-one/tutorials/gitlab/#configuring-ssh
  programs.ssh.matchBlocks."ssh.git.moonythm.dev".proxyCommand = "${lib.getExe pkgs.cloudflared} access ssh --hostname %h";
}
