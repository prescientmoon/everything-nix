{ inputs, lib, pkgs, config, outputs, ... }:
let
  # {{{ Imports
  imports = [
    inputs.stylix.homeManagerModules.stylix
    inputs.homeage.homeManagerModules.homeage
    inputs.nur.nixosModules.nur
    inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.hyprland.homeManagerModules.default

    ../features/cli
    ../features/neovim
    ../../../common
  ];
  # }}} 
  # {{{ Overlays
  overlays = [
    # inputs.neovim-nightly-overlay.overlay
    inputs.agenix.overlay
  ];
  # }}}
in
{
  # Import all modules defined in modules/home-manager
  imports = builtins.attrValues outputs.homeManagerModules ++ imports;

  # {{{ Nixpkgs
  nixpkgs = {
    # Add all overlays defined in the overlays directory
    overlays = builtins.attrValues outputs.overlays ++ overlays;

    # Allow unfree packages
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
  # }}}

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Enable the home-manager and git clis
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  # Set reasonable defaults for some settings
  home = {
    username = lib.mkDefault "adrielus";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };

  # Where homeage should look for our ssh key
  homeage.identityPaths = [ "~/.ssh/id_ed25519" ];

  # Allow root to read persistent files from this user.
  home.persistence."/persist/home/adrielus".allowOther = true;

  # Set the xdg env vars
  xdg.enable = true;

  # {{{ Create xdg user directories
  xdg.userDirs = {
    enable = lib.mkDefault true;
    createDirectories = lib.mkDefault true;
    extraConfig.XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
  };
  # }}}
  # {{{ Ad-hoc stylix targets
  stylix.targets.gtk.enable = true;
  # TODO: is this useful outside xorg?
  stylix.targets.xresources.enable = true;
  # }}}
}
