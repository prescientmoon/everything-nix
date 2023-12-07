{ pkgs, config, lib, ... }:
{
  # {{{ Fzf 
  programs.fzf = {
    enable = true;
    defaultOptions = [ "--no-scrollbar" ];


    changeDirWidgetOptions = [
      "--preview '${lib.getExe pkgs.eza} --icons --tree --color=always {}'"
    ];

    fileWidgetOptions = [
      "--preview '${lib.getExe pkgs.bat} --number --color=always {}'"
    ];
  };

  stylix.targets.fzf.enable = true;
  # }}}
  # {{{ Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./config.fish;

    # {{{ Plugins 
    plugins =
      let
        plugins = with pkgs.fishPlugins; [
          z # Jump to directories by typing "z <directory-name>"
          grc # Adds color to a bunch of built in commands
          done # Trigger a notification when long commands finish execution
          puffer # Text expansion (i.e. expanding .... to ../../../)
          sponge # Remove failed commands and whatnot from history
          forgit # Git tui thingy? (I'm still trying this one out)
          colored-man-pages # Self explainatory:)
        ];
      in
      # For some reason home-manager expects a slightly different format 🤔
      lib.forEach plugins
        (plugin: {
          name = plugin.pname;
          inherit (plugin) src;
        });
    # }}}
  };

  satellite.persistence.at.state.apps.fish.directories = [
    "${config.xdg.dataHome}/fish"
    "${config.xdg.dataHome}/z" # The z fish plugin
  ];
  # }}}
}
