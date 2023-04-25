{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [
    ../common/global
    ../common/users/adrielus.nix

    ../common/optional/pipewire.nix
    ../common/optional/touchpad.nix
    ../common/optional/xserver.nix
    ../common/optional/lightdm.nix
    ../common/optional/steam.nix
    ../common/optional/slambda.nix
    ../common/optional/xmonad

    ./hardware-configuration.nix
    ./boot.nix
  ];

  # Set the name of this machine!
  networking.hostName = "tethys";

  # A few ad-hoc settings
  hardware.opengl.enable = true;
  programs.kdeconnect.enable = true;
  programs.extra-container.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  # Temp stuff:
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE adrielus WITH
             LOGIN
             SUPERUSER
             INHERIT
             CREATEDB
             CREATEROLE
             REPLICATION;
      CREATE DATABASE lunarbox;
      GRANT ALL PRIVILEGES ON DATABASE lunarbox TO adrielus;
    '';
  };
}
