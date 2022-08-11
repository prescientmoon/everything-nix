{ pkgs, ... }: {
  home-manager.users.adrielus = {

    home.packages = with pkgs; [
      idris2
      idris2-pkgs.lsp # idris2
    ];
  };
}
