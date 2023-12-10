{
  imports = [ ../../common/optional/services/syncthing.nix ];

  networking.firewall.allowedTCPPorts = [ 8384 ];

  services.syncthing = {
    guiAddress = "0.0.0.0:8384"; # TODO: put this behind nginx

    settings.folders = { };
  };
}
