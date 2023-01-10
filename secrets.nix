let
  adrielus = builtins.readFile ./hosts/nixos/tethys/id_ed25519.pub;
in
{
  "./hosts/nixos/common/global/wireless/wifi_passwords.age".publicKeys = [ adrielus ];
  "./hosts/nixos/common/users/adrielus_password.age".publicKeys = [ adrielus ];
  "./home/adrielus/features/desktop/common/wakatime/wakatime_config.age".publicKeys = [ adrielus ];
}
