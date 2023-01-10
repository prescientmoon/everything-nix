{ inputs, lib, pkgs, config, outputs, ... }:
let
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.base16.homeManagerModule

    ../features/cli
    ../features/neovim
  ];

  # Import all modules defined in modules/home-manager
  moduleImports = builtins.attrValues outputs.homeManagerModules;
in
{
  imports = imports ++ moduleImports;

  nixpkgs = {
    # Add all overlays defined in the overlays directory
    overlays = builtins.attrValues outputs.overlays ++ 
    [
  inputs.neovim-nightly-overlay.overlay
    ];

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

  scheme = lib.mkDefault "${inputs.catppuccin-base16}/base16/latte.yaml";

  # Set reasonable defaults for some settings
  home = {
    username = lib.mkDefault "adrielus";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };
}
