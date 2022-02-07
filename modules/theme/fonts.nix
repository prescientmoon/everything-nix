{ pkgs, ... }:
let
  nerdfonts =
    (pkgs.nerdfonts.override {
      fonts = [ "FiraCode" "SourceCodePro" ];
    });
in
{
  home-manager.users.adrielus = {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # fira-code
      # fira-code-symbols
      # source-code-pro
      corefonts
      nerdfonts
    ];
  };
}
