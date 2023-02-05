{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    shellAbbrs = {
      cat = "bat";
    };

    shellAliases = {
      # Print available battery
      battery = "acpi";
    };

    plugins = with pkgs.fishPlugins; [
      # Jump to directories by typing "z <directory-name>"
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
          sha256 = "1kaa0k9d535jnvy8vnyxd869jgs0ky6yg55ac1mxcxm8n0rh2mgq";
        };
      }
    ];

    interactiveShellInit =
      # Start tmux if not already inside tmux
      ''
        if status is-interactive
        and not set -q TMUX
            exec tmux attach -t Welcome || tmux || echo "Something went wrong trying to start tmux"
        end
      '' +
      # Sets cursor based on vim mode
      ''
        set fish_cursor_default block # Set the normal and visual mode cursors to a block
        set fish_cursor_insert line # Set the insert mode cursor to a line
        set fish_cursor_replace_one underscore # Set the replace mode cursor to an underscore

        # Force fish to skip some checks (I think?)
        set fish_vi_force_cursor 
      '' +
      # Use vim-style keybinds
      ''
        function fish_user_key_bindings
          # Use the vim keybinds
          fish_vi_key_bindings

          bind -e -M insert -k f10 # unbinds f10
          bind -M insert -m default -k f10 'commandline -f repaint' # Exit insert mode with <f10>
        end
      '';
  };
}
