{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs.easy-dhall-nix; [
    dhall-simple
    dhall-json-simple
    dhall-bash-simple
    dhall-nix-simple
    dhall-yaml-simple
    dhall-lsp-simple
  ];
}
