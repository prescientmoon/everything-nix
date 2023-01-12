let
  adrielus = builtins.readFile ./hosts/nixos/tethys/id_ed25519.pub;
  tethys = builtins.readFile ./hosts/nixos/tethys/ssh_host_ed25519_key.pub;
in
{
  # Scoped for entire systems
  "./hosts/nixos/common/global/wireless/wifi_passwords.age".publicKeys = [ adrielus tethys ];
  "./hosts/nixos/common/users/adrielus_password.age".publicKeys = [ adrielus tethys ];

  # Scoped for the user
  "./home/adrielus/features/desktop/common/wakatime/wakatime_config.age".publicKeys = [ adrielus ];
}
