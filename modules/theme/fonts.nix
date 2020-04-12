{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    source-code-pro
  ];
}
