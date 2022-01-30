final: prev:

let
  config-nvim = final.vimUtils.buildVimPluginFrom2Nix {
    name = "config-nvim";
    src = ../../dotfiles/neovim;
  };

in {
  my-neovim = final.callPackage ../applications/neovim.nix {
    neovim = final.neovim-nightly;
    inherit config-nvim;
  };
}
