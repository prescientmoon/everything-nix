{ inputs, lib, pkgs, config, outputs, colorscheme, ... }:
let
  # Extra modules to import
  imports = [
    inputs.base16.homeManagerModule
    inputs.homeage.homeManagerModules.homeage
    # inputs.impermanence.nixosModules.home-manager.impermanence

    ../features/cli
    ../features/neovim
  ];

  # Extra overlays to add
  overlays = [
    inputs.neovim-nightly-overlay.overlay
  ];
in
{
  # Import all modules defined in modules/home-manager
  imports = builtins.attrValues outputs.homeManagerModules ++ imports;

  nixpkgs = {
    # Add all overlays defined in the overlays directory
    overlays = builtins.attrValues outputs.overlays ++ overlays;

    # Allow unfree packages
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Enable the home-manager and git clis
  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  # Set default theme
  scheme = lib.mkDefault colorscheme;

  # Set reasonable defaults for some settings
  home = {
    username = lib.mkDefault "adrielus";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };

  # Where homeage should look for our ssh key
  homeage.identityPaths = [ "~/.ssh/id_ed25519" ];
}
