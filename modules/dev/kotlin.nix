{ pkgs, ... }: {
  home-manager.users.adrielus = {
    home.packages = with pkgs; [
      kotlin
      gradle
      jdk
      android-studio
    ];
  };
}
