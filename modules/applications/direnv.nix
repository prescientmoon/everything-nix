# https://github.com/nix-community/nix-direnv
{ pkgs, ... }: {
  home-manager.users.adrielus = {
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
