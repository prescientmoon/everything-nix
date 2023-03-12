{ inputs, lib, pkgs, config, outputs, ... }:
let
  # Extra modules to import
  imports = [
    inputs.stylix.homeManagerModules.stylix
    inputs.homeage.homeManagerModules.homeage
    inputs.nur.nixosModules.nur
    # inputs.impermanence.nixosModules.home-manager.impermanence

    ../features/cli
    ../features/neovim
    ../../../common
  ];

  # Extra overlays to add
  overlays = [
    inputs.neovim-nightly-overlay.overlay
    inputs.agenix.overlay
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

  # Set reasonable defaults for some settings
  home = {
    username = lib.mkDefault "adrielus";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.11";
  };

  # Where homeage should look for our ssh key
  homeage.identityPaths = [ "~/.ssh/id_ed25519" ];
}
