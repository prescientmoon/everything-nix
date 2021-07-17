{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    liveRestore = false;
    extraOptions = ''
      --default-address-pool "base=192.168.100.0/20,size=24"
    '';
  };
  home-manager.users.adrielus.home.packages = with pkgs; [
    docker
    docker-compose
    docker-machine
  ];
}
