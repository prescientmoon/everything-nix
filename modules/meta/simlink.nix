# This is a home-manager config!!!
{ pkgs, lib, config, ... }: with lib; {
  options.home.sfile = mkOption {
    description = "Attribute set of files to link into the user home without placing them into the store first";
    default = { };
    type = types.attrsOf types.string;
  };
  config.systemd.user.tmpfiles.rules = mapAttrsToList
    (name: value:
      "L+ ${name} - - - - ${value}"
    )
    config.home.sfile;
}
