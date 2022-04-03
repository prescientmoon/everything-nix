{ pkgs, ... }:
with import ../secrets.nix; {
  # options = {
  #   myUser = {
  #     type = lib.types.string;
  #     default = "";
  #   };
  # };

  # config = {
  # myUser = "adrielus";

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
      inherit hashedPassword;

      extraGroups = [ "wheel" "networkmanager" "lp" "docker" ];
      isNormalUser = true;
      shell = pkgs.fish;
    };
  };
  # };
}
