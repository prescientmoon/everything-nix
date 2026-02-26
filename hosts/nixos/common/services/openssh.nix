{
  outputs,
  config,
  lib,
  ...
}:
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

    # Generate host ssh keys
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

    # Add each host in this repo to the knownHosts list
    knownHosts =
      let
        mkKnownHost = kind: name: _: {
          name = "${name}/${kind}";
          value = {
            publicKeyFile = ../../../${name}/keys/ssh_host_${kind}_key.pub;
            hostNames = [ name ] ++ lib.lists.optional (name == config.networking.hostName) "localhost";
          };
        };

        mkKnownHosts =
          kind:
          lib.pipe outputs.nixosConfigurations [
            # attrsetof host -> attrsetof { ... }
            (lib.attrsets.mapAttrs' (mkKnownHost kind))

            (lib.attrsets.filterAttrs
              # Only let through hosts with a valid key file
              (_: { publicKeyFile, ... }: builtins.pathExists publicKeyFile)
            )
          ];
      in
      mkKnownHosts "ed25519" // mkKnownHosts "rsa";
  };

  # By default, this will ban failed ssh attempts
  services.fail2ban.enable = lib.mkDefault true;

  # Helps with latency
  programs.mosh.enable = true;

  # Makes it easy to copy host keys at install time without messing up permissions
  systemd.tmpfiles.rules = [
    "d /persist/state/etc/ssh"
  ]
  ++ (lib.lists.forEach config.services.openssh.hostKeys (key: "e ${key.path} 0700"));
}
