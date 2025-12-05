{
  pkgs,
  config,
  lib,
  ...
}:
{
  # {{{ FZF
  programs.fzf = {
    enable = true;
    defaultOptions = [ "--no-scrollbar" ];

    changeDirWidgetOptions = [ "--preview '${lib.getExe pkgs.eza} --icons --tree --color=always {}'" ];
    fileWidgetOptions = [ "--preview '${lib.getExe pkgs.bat} --number --color=always {}'" ];
  };

  stylix.targets.fzf.enable = true;
  # }}}
  # {{{ Fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      ${builtins.readFile ./config.fish}

      # Modify nix-shell to use `fish` as its default shell
      ${lib.getExe pkgs.nix-your-shell} fish | source
    '';

    # {{{ Plugins
    plugins =
      let
        plugins = with pkgs.fishPlugins; [
          z # Jump to directories by typing "z <directory-name>"
          done # Trigger a notification when long commands finish execution
          puffer # Text expansion (i.e. expanding .... to ../../../)
        ];
      in
      # For some reason home-manager expects a slightly different format 🤔
      lib.forEach plugins (plugin: {
        inherit (plugin) src;
        name = plugin.pname;
      });
    # }}}
  };

  satellite.persistence.at.state.apps.fish.directories = [
    "${config.xdg.dataHome}/fish"
    "${config.xdg.dataHome}/z" # The z fish plugin requires this
  ];
  # }}}
}
