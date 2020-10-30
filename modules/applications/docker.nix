{ pkgs, ... }: {
  virtualisation.docker.enable = true;
  home-manager.users.adrielus.home.packages = with pkgs; [
    docker
    docker-compose
  ];
}
