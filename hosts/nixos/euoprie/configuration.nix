{ pkgs, ... }: {
  # Enable the firewall.
  networking.firewall.enable = true;

  # Set the name of this machine!
  networking.hostName = "euporie";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";


  services.sourcehut = {
    # enable = true;
    # meta.enable = true;
    # paste.enable = true;
    # hub.enable = true;
  };
}
