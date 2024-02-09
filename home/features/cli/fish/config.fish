# {{{ Start tmux if not already inside tmux
if status is-interactive
and not set -q TMUX
and not set -q NO_TMUX
and set -q ALWAYS_TMUX
    exec tmux attach -t Welcome || tmux || echo "Something went wrong trying to start tmux"
end
# }}}
# {{{ Sets cursor based on vim mode
set fish_cursor_default block # Set the normal and visual mode cursors to a block
set fish_cursor_insert line # Set the insert mode cursor to a line
set fish_cursor_replace_one underscore # Set the replace mode cursor to an underscore

# Force fish to skip some checks (I think?)
# TODO: research why this is here
set fish_vi_force_cursor
# }}}
# {{{ Disable greeting
set fish_greeting
# }}}
# {{{ Keybinds
function fish_user_key_bindings
  fish_vi_key_bindings
  fish_nix_key_bindings

  bind -M insert -m default -k f10 'commandline -f repaint' # Exit insert mode with <f10>
end
# }}}
# {{{ Helpers
function take -d "Create a directory and cd into it"
  mkdir $argv; and cd $argv
end
# }}}
