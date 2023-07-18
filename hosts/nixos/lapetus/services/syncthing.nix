{
  imports = [ ../../common/optional/syncthing.nix ];

  services.syncthing = {
    devices.lapetus.id = "";
    guiAddress = "0.0.0.0:8384"; # TODO: put this behind nginx

    folders = { };
  };
}
