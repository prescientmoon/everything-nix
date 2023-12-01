{ pkgs, config, lib, ... }:
{
  programs.fish = {
    enable = true;

    plugins =
      let
        plugins = with pkgs.fishPlugins; [
          z # Jump to directories by typing "z <directory-name>"
          grc # Adds color to a bunch of built in commands
          done # Trigger a notification when long commands finish execution
          puffer # Text expansion (i.e. expanding .... to ../../../)
          sponge # Remove failed commands and whatnot from history
          forgit # Git tui thingy? (I'm still trying this one out)
          fzf-fish # Fuzzy finder for things like files
          colored-man-pages # Self explainatory:)
        ];
      in
      # For some reason home-manager expects a slightly different format 🤔
      lib.forEach plugins
        (plugin: {
          name = plugin.pname;
          inherit (plugin) src;
        });

    interactiveShellInit = builtins.readFile ./config.fish;
  };

  satellite.persistence.at.state.apps.fish.directories = [
    "${config.xdg.dataHome}/fish"
    "${config.xdg.dataHome}/z" # The z fish plugin
  ];
}
