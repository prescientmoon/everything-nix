{ ... }: {
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
  };
}
