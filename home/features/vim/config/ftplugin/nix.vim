function! UpdateNixFetchgit()
  let l:state = winsaveview()
  %!update-nix-fetchgit
  call winrestview(l:state)
endfunction
nnoremap <buffer> <leader>lg :call UpdateNixFetchgit()<cr>
