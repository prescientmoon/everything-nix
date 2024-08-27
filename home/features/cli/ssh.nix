{ config, ... }:
{
  programs.ssh.enable = true;

  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];
  systemd.user.tmpfiles.rules =
    let
      ssh = "${config.satellite.persistence.at.state.home}/ssh/.ssh";
    in
    [
      "d ${ssh} 0755 ${config.home.username} users"
      "e ${ssh}/id_rsa 0700 ${config.home.username} users"
      "e ${ssh}/id_ed25519 0700 ${config.home.username} users"
    ];
}
