{ pkgs, ... }:
{
  # {{{ Imports
  imports = [
    ./global.nix
    ./features/desktop/foot.nix
    ./features/wayland/hyprland
  ];
  # }}}
  # {{{ Arbitrary extra packages
  programs.firefox.enable = true;

  home.packages =
    let
      cloneConfig = pkgs.writeShellScriptBin "liftoff" ''
        git clone git@github.com:prescientmoon/everything-nix.git
        cd everything-nix
      '';
    in
    with pkgs;
    [
      sops # Secret editing
      neovim # Text editor
      cloneConfig # Clones my nixos config from github
    ];
  # }}}

  home.stateVersion = "24.05";
}
