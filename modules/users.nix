{ pkgs, ... }:
{
  # Disable asking for password for sudo
  security.sudo.extraRules = [
    {
      users = [ "adrielus" ];
      commands = [{
        command = "ALL";
        options = [ "SETENV" "NOPASSWD" ];
      }];
    }
  ];

  users = {
    mutableUsers = false;
    users.adrielus = {
      passwordFile = "~/water/pass";
      extraGroups = [ "wheel" "networkmanager" "lp" "docker" "audio" "sound" "video" "input" "tty" ];
      isNormalUser = true;
      shell = pkgs.fish;
    };
  };
  # };
}
