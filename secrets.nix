let
  tethys = builtins.readFile ./hosts/nixos/tethys/keys/ssh_host_ed25519_key.pub;
  lapetus = builtins.readFile ./hosts/nixos/lapetus/keys/ssh_host_ed25519_key.pub;

  adrielus_tethys = builtins.readFile ./hosts/nixos/tethys/keys/id_ed25519.pub;
  adrielus_lapetus = builtins.readFile ./hosts/nixos/lapetus/keys/id_ed25519.pub;

  all_hosts = [ tethys lapetus ];
in
{
  # Scoped for entire systems
  "./hosts/nixos/common/global/wireless/wifi_passwords.age".publicKeys = all_hosts ++ [ adrielus_tethys ];
  "./hosts/nixos/common/users/adrielus_password.age".publicKeys = all_hosts ++ [ adrielus_tethys ];

  # Scoped for the user
  # TODO: perhaps move this into `pass`?.
  "./home/features/desktop/wakatime/wakatime_config.age".publicKeys = [ adrielus_tethys ];
  "./home/features/cli/productivity/smos/smos_github_oauth.age".publicKeys = [ adrielus_tethys ];
}
