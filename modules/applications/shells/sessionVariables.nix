{ ... }:
with import ../../../secrets.nix;
let
  theme = "github-dark";
  variables = {
    # Configure github cli
    GITHUB_USERNAME = "Mateiadrielrafael";
    inherit GITHUB_TOKEN;

    # Sets neovim as default editor
    EDITOR = "nvim";

    # Sets the current theme used by all programs
    THEME = theme;

    # Common command for launching alacritty with the correct theme
    # LAUNCH_ALACRITTY = "alacritty --config-file ~/.config/alacritty/themes/$THEME.yml";
  };
in
{
  home-manager.users.adrielus = { home.sessionVariables = variables; };
}
