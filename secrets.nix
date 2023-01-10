let
  tethys = builtins.readFile ./hosts/nixos/tethys/ssh_host_ed25519_key.pub;
in
{
  "./hosts/nixos/common/global/wireless/wifi_passwords.age".publicKeys = [ tethys ];
  "./hosts/nixos/common/users/adrielus_password.age".publicKeys = [ tethys ];
  "./home/adrielus/features/desktop/common/wakatime/wakatime_config.age".publicKeys = [ tethys ];
}
