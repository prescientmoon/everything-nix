{ pkgs, ... }:
with import ../secrets.nix; {
  users = {
    mutableUsers = false;
    users.adrielus = {
      inherit hashedPassword;

      extraGroups = [ "wheel" "networkmanager" "lp" ];
      isNormalUser = true;
      shell = pkgs.fish;
    };
  };
}
