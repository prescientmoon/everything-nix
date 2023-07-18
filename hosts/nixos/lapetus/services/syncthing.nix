{
  imports = [ ../../common/optional/syncthing.nix ];

  networking.firewall.allowedTCPPorts = [ 8384 ];

  services.syncthing = {
    devices.lapetus.id = "VVHM7RC-ZSDOZJI-EGBIJR4-2DOGAXG-OEJZWSH-OYUK5XT-7CDMWSL-3AVM2AZ";
    guiAddress = "0.0.0.0:8384"; # TODO: put this behind nginx

    folders = { };
  };
}
