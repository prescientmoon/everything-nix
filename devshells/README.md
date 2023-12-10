# Devshells

Nix shells accessible via `nix develop` (or the legacy `nix-shell`). My projects provide their own shells, but having a few generic ones is still useful for making quick contributions to external projects and the like.

## File structure

| Location                       | Description                                                                   |
| ------------------------------ | ----------------------------------------------------------------------------- |
| [bootstrap](./bootstrap)       | Shell for bootstrapping on non flake-enabled systems                          |
| [haskell](./haskell.nix)       | Common haskell tooling                                                        |
| [purescript](./purescript.nix) | Common purescript tooling                                                     |
| [purescript](./lua.nix)        | Common lua tooling                                                            |
| [purescript](./typst.nix)      | Common lua typst                                                              |
| [rwtw](./rwtw.nix)             | A few randomly cobbled together tools for working on the rain world tech wiki |
