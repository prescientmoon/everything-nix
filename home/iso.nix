{ pkgs, ... }:
{
  imports = [
    ./global.nix

    ./features/desktop/foot.nix
    ./features/desktop/firefox
    ./features/cli/lazygit.nix
    ./features/wayland/hyprland
    ./features/neovim
  ];

  # Arbitrary extra packages
  home.packages = with pkgs; [
    sops # Secret editing
  ];

  home.username = "moon";
  home.stateVersion = "24.05";

  satellite.toggles.neovim-minimal.enable = true;
}
