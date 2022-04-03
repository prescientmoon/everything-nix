{ pkgs, ... }:
let kmonadRoot = ../../dotfiles/kmonad; in
{
  users.extraUsers.adrielus.extraGroups = [ "input" "uinput" ];

  services = {
    kmonad = {
      enable = true;
      configfiles = [ (kmonadRoot + "/keymap.kbd") ];
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
