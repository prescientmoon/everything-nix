{ wrapNeovim, neovim, tree-sitter, config-nvim, vimPlugins, vimExtraPlugins }:

wrapNeovim neovim {
  configure = {
    customRC = ''
      let g:disable_paq = v:true
      luafile ${config-nvim}/init.lua
    '';

    packages.default = with vimExtraPlugins; {
      start = [ config-nvim vimExtraPlugins.github-nvim-theme ];
    };
  };
}
