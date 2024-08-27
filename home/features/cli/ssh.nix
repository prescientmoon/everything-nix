{ config, ... }:
{
  programs.ssh.enable = true;

  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];
  systemd.user.tmpfiles.rules =
    let
      ssh = "${config.satellite.persistence.at.state.home}/ssh/.ssh";
    in
    [
      "d ${ssh}/ssh/.ssh ${config.home.username} users 0755"
      "e ${ssh}/ssh/.ssh/id_rsa ${config.home.username} users 0700"
      "e ${ssh}/id_ed25519 ${config.home.username} users 0700"
    ];
}
