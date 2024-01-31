{
  programs.ssh.enable = true;

  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];

  # Makes it easy to copy ssh keys at install time without messing up permissions
  systemd.user.tmpfiles.rules = [ "d /persist/state/home/adrielus/ssh/.ssh/etc/ssh" ];
}
