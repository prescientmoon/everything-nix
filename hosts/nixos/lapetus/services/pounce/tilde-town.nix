{
  config,
  pkgs,
  ...
}:
let
  user = config.services.pounce.user;
in
{
  sops.secrets.pounce_ssh_tunnel_key = {
    sopsFile = ../../secrets.yaml;
    owner = user;
    group = user;
  };

  # Set up a tunnel to tilde.town's IRC network
  systemd.services.tilde-town-irc-tunnel = {
    enable = true;
    description = "A SSH tunnel to tilde.town's IRC network";
    after = [ "network.target" ];
    before = [ "pounce-town.service" ];
    requiredBy = [ "pounce-town.service" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = "5s";
      User = user;
      Group = user;

      # -N: do not execute a remote command
      # -T: do not allocate a remote terminal
      # -o ServerAliveInterval=60: time out if no data is received for a minute
      # -o ExitOnForwardFailure=yes: error if the tunneling cannot be set up
      ExecStart = ''
        ${pkgs.openssh}/bin/ssh \
          -NT \
          -o ServerAliveInterval=60 \
          -o ExitOnForwardFailure=yes \
          -i ${config.sops.secrets.pounce_ssh_tunnel_key.path} \
          -L ${toString config.satellite.ports.tilde-town-irc}:localhost:6697 \
          prescientmoon@tilde.town
      '';
    };
  };

  services.openssh.knownHosts = {
    "tilde.town/ed25519" = {
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILaUC+zvnSwWE+QdUy+H/SX83/Tn8gHmwX02YuGddUp2";
      hostNames = [ "tilde.town" ];
    };

    "tilde.town/rsa" = {
      publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtXM7GRoh9TOqsn29Aj/tF6+VyVXNXSxdK8MlYfevwLoydAgP7mCqaAwRYRX9DLl4sviiyCeZWF65Bz9uA+QOuveBK1g+EaZKNt5AJ4YSWmMiHq9RAfiLz2NiJsAGqeOOcaMtGIpms69jhI6PATjVwsnJ7MBXPbmy4kiUfzuXIvSZ632KZcVjUcXZgBp7v2pjCgC4os/v5khHunuYlnZPSmB7KjAUFAlQnEzZ9/vSyHm34mb7MtHESKNzFRPnsqDe4ET5arPHkiBUnhIOIiCl8g2kBZWgXapgfK5QKJ82mwxs1lKFzIj+oXMqdpfWx4iCdMv/fMtwIEEVnhEsxbjiV";
      hostNames = [ "tilde.town" ];
    };

    "tilde.town/ecdsa" = {
      publicKey = "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGyMV3ZnH1L3M7iZwS6RYEpjV7xEOFe9SizkjFuua9u1okyUs3Jg0SygmCkelbUHq06mjvhPpKCP9W2SsQ+M2vc=";
      hostNames = [ "tilde.town" ];
    };
  };
}
