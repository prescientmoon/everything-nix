let
  tethys = builtins.readFile ./hosts/nixos/tethys/ssh_host_ed25519_key.pub;
  lapetus = builtins.readFile ./hosts/nixos/lapetus/ssh_host_ed25519_key.pub;

  adrielus_tethys = builtins.readFile ./hosts/nixos/tethys/id_ed25519.pub;
  adrielus_lapetus = builtins.readFile ./hosts/nixos/lapetus/id_ed25519.pub;

  all_hosts = [ tethys lapetus ];
in
{
  # Scoped for entire systems
  "./hosts/nixos/common/global/wireless/wifi_passwords.age".publicKeys = all_hosts ++ [ adrielus_tethys ];
  "./hosts/nixos/common/users/adrielus_password.age".publicKeys = all_hosts ++ [ adrielus_tethys ];

  # Scoped for the user
  # TODO: move this into `pass`.
  "./home/features/desktop/wakatime/wakatime_config.age".publicKeys = [ adrielus_tethys ];
}
