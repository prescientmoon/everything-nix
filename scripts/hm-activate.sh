#!/run/current-system/sw/bin/bash
if [ $# -eq 0 ]
  then
    ~/.local/share/hm-result/activate
  else 
    ~/.local/share/hm-result/specialization/$1/activate
fi
