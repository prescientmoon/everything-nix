# My own module with nicer syntax for impernanence 
{ lib, config, ... }:
let cfg = config.satellite.persistence;
in
{
  options.satellite.persistence = {
    enable = lib.mkEnableOption "satellite persitence";

    at = lib.mkOption {
      default = { };
      description = "Record of persistent locations (eg: /persist)";
      type = lib.types.attrsOf (lib.types.submodule (_: {
        options = {
          path = lib.mkOption {
            type = lib.types.str;
            example = "/persist";
            default = null;
            description = "The location to store the files described in this record";
          };

          apps = lib.mkOption {
            default = { };
            description = "The apps to be stores in this persistent location";
            type = lib.types.attrsOf (lib.types.submodule (_: {
              options = {
                directories = lib.mkOption {
                  default = [ ];
                  description = "Modified version of home.persistence.*.directories which takes in absolute paths";
                  type = lib.types.listOf (lib.types.either lib.types.str (lib.types.submodule {
                    options = {
                      directory = lib.mkOption {
                        type = lib.types.str;
                        default = null;
                        description = "The directory path to be linked.";
                      };

                      method = lib.mkOption {
                        type = lib.types.enum [ "bindfs" "symlink" ];
                        default = "bindfs";
                        description = ''
                          The linking method that should be used for this
                          directory. bindfs is the default and works for most use
                          cases, however some programs may behave better with
                          symlinks.
                        '';
                      };
                    };
                  }));
                };
              };
            }));
          };
        };
      }));
    };
  };

  config =
    let
      makeLocation = location:
        let
          processPath = appName: value:
            "${appName}/${lib.strings.removePrefix config.home.homeDirectory (builtins.toString value)}";

          mkDirectory = appName: directory:
            if builtins.isAttrs directory then {
              method = directory.method;
              directory = processPath appName directory.directory;
            }
            else processPath appName directory;

          mkAppDirectory = appName: app: builtins.map (mkDirectory appName) app.directories;
        in
        lib.attrsets.nameValuePair (location.path + config.home.homeDirectory) {
          removePrefixDirectory = true;
          allowOther = true;
          directories = lib.lists.flatten
            (lib.attrsets.mapAttrsToList mkAppDirectory location.apps);
        };
    in
    lib.mkIf cfg.enable {
      home.persistence = lib.attrsets.mapAttrs' (_: makeLocation) cfg.at;
    };
}
