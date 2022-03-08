# Make normal mode the default
set vi_mode_default vi_mode_normal

function vi_mode_user_key_bindings
  echo "Added keybinds (hopefully)"
  bind jj 'commandline -f backward-char; vi_mode_normal'    
end
