{ inputs, lib, pkgs, config, outputs, ... }:
let
  # Extra modules to import
  imports = [
    inputs.base16.homeManagerModule
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
  moduleImports = builtins.attrValues outputs.homeManagerModules ++ imports;

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
  scheme = lib.mkDefault "${inputs.catppuccin-base16}/base16/latte.yaml";

  # Set reasonable defaults for some settings
  home = {
    username = lib.mkDefault "adrielus";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };
}
