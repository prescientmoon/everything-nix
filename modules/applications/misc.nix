{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # Tool to allow hashing passwords from the cmd
    mkpasswd

    vscodium
    google-chrome
    discord
    git
  ];
}
