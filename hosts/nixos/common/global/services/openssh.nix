# This setups a SSH server.
{
  outputs,
  config,
  lib,
  ...
}:
let
  # Record containing all the hosts
  hosts = outputs.nixosConfigurations;

  # Name of the current hostname
  hostname = config.networking.hostName;

  # Function from hostname to relative path to public ssh key
  pubKey = host: ../../${host}/keys/ssh_host_ed25519_key.pub;
in
{
  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = lib.mkDefault "no"; # Forbid root login through SSH.
      PasswordAuthentication = lib.mkDefault false; # Use keys only.
    };

    # Automatically remove stale sockets
    extraConfig = ''
      StreamLocalBindUnlink yes
    '';

    # Generate ssh key
    hostKeys =
      let
        mkKey =
          type: path: extra:
          { inherit type path; } // extra;
      in
      [
        (mkKey "ed25519" "/persist/state/etc/ssh/ssh_host_ed25519_key" { })
        (mkKey "rsa" "/persist/state/etc/ssh/ssh_host_rsa_key" { bits = 4096; })
      ];
  };

  # Add each host in this repo to the knownHosts list
  programs.ssh = {
    knownHosts = lib.pipe hosts [
      # attrsetof host -> attrsetof { ... }
      (builtins.mapAttrs
        # string -> host -> { ... }
        (
          name: _: {
            publicKeyFile = pubKey name;
            extraHostNames = lib.optional (name == hostname) "localhost";
          }
        )
      )

      # attrsetof { ... } -> attrsetof { ... }
      (lib.attrsets.filterAttrs
        # string -> { ... } -> bool
        (_: { publicKeyFile, ... }: builtins.pathExists publicKeyFile)
      )
    ];
  };

  # By default, this will ban failed ssh attempts
  services.fail2ban.enable = true;

  # Makes it easy to copy host keys at install time without messing up permissions
  systemd.tmpfiles.rules = [ "d /persist/state/etc/ssh" ];
}
