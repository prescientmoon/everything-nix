{ config, ... }: {
  programs.ssh.enable = true;

  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];

  # Makes it easy to copy ssh keys at install time without messing up permissions
  systemd.user.tmpfiles.rules = [
    "d ${config.satellite.persistence.at.state.home}/ssh/.ssh/etc/ssh"
  ];
}
