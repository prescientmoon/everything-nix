# (https://nixos.wiki/wiki/Module).

{
  # example = import ./example.nix;
  lua-encoders = import ./lua-encoders.nix;
  lua-colorscheme = import ./lua-colorscheme.nix;
  theming = import ./theming.nix;
  toggles = import ./toggles.nix;
  neovim = import ./neovim.nix;
}
