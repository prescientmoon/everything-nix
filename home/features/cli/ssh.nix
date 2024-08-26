{ config, ... }:
{
  programs.ssh.enable = true;

  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];
  systemd.user.tmpfiles.rules =
    let
      ssh = "${config.satellite.persistence.at.state.home}/ssh/.ssh";
    in
    [
      "d ${ssh}/ssh/.ssh"
      "e ${ssh}/ssh/.ssh/id_rsa 0700"
      "e ${ssh}/id_ed25519 0700"
    ];
}
