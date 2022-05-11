{ pkgs, ... }: {
  home-manager.users.adrielus = {

    home.packages = with pkgs; [
      idris2
      idris2-pkgs.lsp # idris2
    ];

    programs.neovim.plugins = with pkgs.vimPlugins;
      with pkgs.vimExtraPlugins; with pkgs.myVimPlugins; [
        nui-nvim # ui lib required by idris plugin
        idris2-nvim # idris2 support
      ];
  };
}
