{
  pkgs,
  config,
  lib,
  ...
}:
let
  repaint = "commandline -f repaint";
  fishKeybinds = {
    # C-x to clear screen
    "ctrl-x" = "clear && ${repaint}";
    # C-z to return to background process
    "ctrl-z" = "fg && ${repaint}";
    # C-y to yank current command
    "ctrl-y" = "wl-copy \$(commandline)";
    # C-e to launch $EDITOR
    "ctrl-e" = "$EDITOR";
    # C-S-e to edit command-line using $EDITOR
    "ctrl-E" = "edit_command_buffer";
    # C-enter to run command through a pager
    "ctrl-enter" = "commandline -a ' | $PAGER' && commandline -f execute";
    # C-g to open lazygit
    "ctrl-g" = "lazygit";
    # C-S-f to open mini.files
    "ctrl-F" = ''nvim +":lua require('mini.files').open()"'';
  };

  mkKeybind =
    key: value:
    let
      escaped = lib.escapeShellArg value;
    in
    ''
      bind -M default ${key} ${escaped}
      bind -M insert  ${key} ${escaped}
    '';
in
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
      # ❄️ Fish keybinds generated using nix ^~^
      function fish_nix_key_bindings
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList mkKeybind fishKeybinds)}
      end

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
