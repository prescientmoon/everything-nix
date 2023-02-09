# {{{ Start tmux if not already inside tmux
if status is-interactive
and not set -q TMUX
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
# {{{ Use vim-style keybinds
function fish_user_key_bindings
  # Use the vim keybinds
  fish_vi_key_bindings

  bind -e -M insert -k f10 # unbinds f10
  bind -M insert -m default -k f10 'commandline -f repaint' # Exit insert mode with <f10>
end
# }}}
