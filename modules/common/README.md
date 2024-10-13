# Common modules

## Home-manage & Nixos modules

| Name                                   | Attribute                   | Description                         |
| -------------------------------------- | --------------------------- | ----------------------------------- |
| [toggles](toggles.nix)                 | `satellite.toggles`         | Generic interface for feature flags |
| [lua-lib](lua-lib.nix)                 | `satellite.lib.lua`         | Helpers for working with lua code   |
| [korora-lua](korora-lua.nix)           | -                           | Nix -> lua encoder                  |
| [korora-neovim](korora-neovim.nix)     | -                           | Nix -> neovim config helpers        |
| [theming](theming.nix)                 | `satellite.theming`         | Stylix theming helpers              |
| [lua-colorscheme](lua-colorscheme.nix) | `satellite.colorscheme.lua` | Base16 theme -> lua                 |
