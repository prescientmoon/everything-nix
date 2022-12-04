{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    unstable.elan # lean version manager
  ];
}
