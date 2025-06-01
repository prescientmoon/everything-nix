# Set cursor based on vim mode
set fish_cursor_default block # Set the normal & visual mode cursors to a block
set fish_cursor_insert line # Set the insert mode cursor to a line
set fish_cursor_replace_one underscore # Set the replace mode cursor to an underscore

# Force fish to skip some checks (I think?)
set fish_vi_force_cursor

# Disable greeting
set fish_greeting

# Key-binds
function fish_user_key_bindings
  fish_vi_key_bindings
  fish_nix_key_bindings

  # Exit insert mode with <f10>
  bind -M insert -m default f10 'commandline -f repaint'
end

# Helpers
function take -d "Create a directory and cd into it"
  mkdir -p $argv; and cd $argv
end
