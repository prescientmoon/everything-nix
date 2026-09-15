{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # The old default settings (no idea what a lot of them mean, but I don't
    # want to break my backwards compatibility :p)
    settings."*" = {
      ForwardAgent = false;
      AddKeysToAgent = "no";
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
    };
  };

  satellite.persistence.at.state.at.ssh.directories = [ ".ssh" ];
}
