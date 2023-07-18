{
  imports = [ ../../common/optional/syncthing.nix ];

  services.syncthing = {
    devices.lapetus.id = "";

    folders = { };
  };
}
