let
  tethys = builtins.readFile ../hosts/nixos/tethys/ssh_host_ed25519_key.pub;
in
{
  "wifi_passwords.age".publicKeys = [ tethys ];
  "adrielus_password.age".publicKeys = [ tethys ];
}
