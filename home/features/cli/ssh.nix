{ pkgs, ... }: {
  programs.ssh.enable = true;

  home.packages = with pkgs; [
    mosh # SSH replacement for slow connections
  ];

  # TODO: persistence
  # home.persistence = {
  #   "/persist/home/adrielus".directories = [ ".ssh" ];
  # };
}
