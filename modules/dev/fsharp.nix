{ pkgs, ... }: {
  home-manager.users.adrielus.home.packages = with pkgs; [
    dotnet-sdk
    mono
    packet
  ];
}
