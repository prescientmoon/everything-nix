{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # The old default settings
    matchBlocks."*" = {
      forwardAgent = false;
      addKeysToAgent = "no";
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";
    };

    # This will be the syntax for the next HM version
    # settings."*" = {
    #   ForwardAgent = false;
    #   AddKeysToAgent = "no";
    #   Compression = false;
    #   ServerAliveInterval = 0;
    #   ServerAliveCountMax = 3;
    #   HashKnownHosts = false;
    #   UserKnownHostsFile = "~/.ssh/known_hosts";
    #   ControlMaster = "no";
    #   ControlPath = "~/.ssh/master-%r@%n:%p";
    #   ControlPersist = "no";
    # };
  };

  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];
}
