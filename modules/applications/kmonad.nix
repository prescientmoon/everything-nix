{ pkgs, lib, ... }:
let
  kmonadRoot = ../../dotfiles/kmonad;
  kmonadInstances = [{
    config = kmonadRoot + "/keymap.kbd";
    inputDevices = [
      "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
    ];
  }];

  createKmonadInstances = ({ config, inputDevices }:
    let
      configContent = builtins.readFile config;
    in
    lib.lists.map
      (device:
        "${pkgs.writeTextDir "configs/kmonad.kbd" (builtins.replaceStrings [ "$DEVICE" ] [ device ] configContent)}/kmonad.kbd"
      )
      inputDevices

  );
in
{
  users.extraUsers.adrielus.extraGroups = [ "input" "uinput" ];

  services = {
    kmonad = {
      enable = true;
      # configfiles = lib.lists.concatMap createKmonadInstances kmonadInstances;
      configfiles = lib.lists.map ({ config, ... }: config) kmonadInstances;
    };

    xserver = {
      xkbOptions = "compose:ralt";
      layout = "us";
    };

  };

  home-manager.users.adrielus = {
    home.file.".XCompose".source = kmonadRoot + "/xcompose";
  };
}
