set fish_cursor_default block # Set the normal and visual mode cursors to a block
set fish_cursor_insert line # Set the insert mode cursor to a line
set fish_cursor_replace_one underscore # Set the replace mode cursor to an underscore

# Force fish to skip some checks (I think)
set fish_vi_force_cursor 

function fish_user_key_bindings
  # Use the vim keybinds
  fish_vi_key_bindings

  # Use jj to exit insert mode
  bind -e -M insert \e # unbinds esc
  bind -M insert -m default jj 'commandline -f repaint'
end
