{ ... }:
with import ../secrets.nix; {
  users = {
    mutableUsers = false;
    users.adrielus = {
      inherit hashedPassword;

      extraGroups = [ "wheel" "networkmanager" ];
      isNormalUser = true;
    };
  };
}
