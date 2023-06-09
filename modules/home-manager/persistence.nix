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

          prefixDirectories = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = false;
            description = "Whether to enable gnu/stow type prefix directories";
          };

          apps = lib.mkOption {
            default = { };
            description = "The apps to be stores in this persistent location";
            type = lib.types.attrsOf (lib.types.submodule (_: {
              options = {
                files = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  example = [ ".screenrc" ];
                  description = ''
                    A list of files in your home directory you want to
                    link to persistent storage. Allows both absolute paths
                    and paths relative to the home directory. .
                  '';
                };

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
                        default = "symlink";
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
            let
              suffix = "${lib.strings.removePrefix "${config.home.homeDirectory}/" (builtins.toString value)}";
              prefix = if location.prefixDirectories then "${appName}/" else "";
            in
            # lib.debug.traceSeq "\nProcessing path at location ${location.path} and app ${appName} from original path ${value} to ${prefix + suffix}" 
            (prefix + suffix);

          mkDirectory = appName: directory:
            if builtins.isAttrs directory then {
              method = directory.method;
              directory = processPath appName directory.directory;
            }
            else processPath appName directory;

          mkAppDirectory = appName: app: builtins.map (mkDirectory appName) app.directories;
          mkAppFiles = appName: app: builtins.map (processPath appName) app.files;
        in
        lib.attrsets.nameValuePair (location.path + config.home.homeDirectory) {
          removePrefixDirectory = location.prefixDirectories;
          allowOther = true;
          directories = lib.lists.flatten
            (lib.attrsets.mapAttrsToList mkAppDirectory location.apps);

          files = lib.lists.flatten
            (lib.attrsets.mapAttrsToList mkAppFiles location.apps);
        };
    in
    lib.mkIf cfg.enable {
      home.persistence = lib.attrsets.mapAttrs' (_: makeLocation) cfg.at;
    };
}
