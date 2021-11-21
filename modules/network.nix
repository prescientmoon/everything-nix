{ ... }: {
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";

    useDHCP = false;
    interfaces.enp1s0.useDHCP = true;
    interfaces.wlp0s20f3.useDHCP = true;
  };
}
