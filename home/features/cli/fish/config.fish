# Set cursor based on vim mode
set fish_cursor_default block # Set the normal & visual mode cursors to a block
set fish_cursor_insert line # Set the insert mode cursor to a line
set fish_cursor_replace_one underscore # Set the replace mode cursor to an underscore

# Force fish to skip some checks (I think?)
set fish_vi_force_cursor

# Disable greeting
set fish_greeting

# Bind something in both normal and insert mode
function bind_both --description "Bind a key in both normal and insert modes"
  if test (count $argv) -lt 2
    echo "Usage: bind_both <key> <..commands>"
    return 1
  end

  set key $argv[1]
  set cmd $argv[2..-1]

  bind -M default $key $cmd
  bind -M insert  $key $cmd
end

# Key-binds
function fish_user_key_bindings
  fish_vi_key_bindings

  # Exit insert mode with <f10>
  bind -M insert -m default f10 repaint

  # Restore the old $ functionality
  bind -M default '$' accept-autosuggestion end-of-line

  bind_both 'ctrl-x' clear repaint
  bind_both 'ctrl-z' fg repaint
  bind_both 'ctrl-y' \
    'wl-copy $(commandline)' \
    'notify-send "Command copied to clipboard: $(wl-paste)"'
  bind_both 'ctrl-e' '$EDITOR';
  bind_both 'ctrl-e' edit_command_buffer
  bind_both 'ctrl-enter' 'commandline -a \' | $PAGER\'' execute
  bind_both 'ctrl-g' lazygit
  bind_both 'ctrl-F' 'nvim +":lua require(\'mini.files\').open()"';
end

# Helpers
function take -d "Create a directory and cd into it"
  if test (count $argv) -ne 1
    echo "Usage: take <directory>"
    return 1
  end

  mkdir -p $argv
  and cd $argv
end
