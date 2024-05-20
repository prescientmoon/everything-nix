# My own module with nicer syntax for impernanence
{ lib, config, ... }:
let cfg = config.satellite.persistence;
in
{
  # {{{ Option definition
  options.satellite.persistence = {
    enable = lib.mkEnableOption "satellite persistence";

    at = lib.mkOption {
      default = { };
      description = "Record of persistent locations (eg: /persist)";
      type = lib.types.attrsOf (lib.types.submodule (args: {
        config = {
          home = "${args.config.path}${config.home.homeDirectory}";
        };

        options = {
          # {{{ Location options
          path = lib.mkOption {
            type = lib.types.str;
            example = "/persist";
            description = "The root location to store the home directory for files in this record";
          };

          home = lib.mkOption {
            type = lib.types.str;
            description = "The path to the home directory for files in this record";
          };

          prefixDirectories = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether to enable gnu/stow type prefix directories";
          };
          # }}}
          # {{{ Apps
          apps = lib.mkOption {
            default = { };
            description = "Record of gnu/stow-style apps to be stored in this location";
            type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
              options = {
                name = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                  description = "The gnu/stow-style subdirectory name";
                };

                files = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  example = [ ".screenrc" ];
                  description = ''
                    A list of files in your home directory you want to
                    link to persistent storage. Allows both absolute paths
                    and paths relative to the home directory.
                  '';
                };

                directories = lib.mkOption {
                  default = [ ];
                  description = ''
                    Modified version of `home.persistence.*.directories` which takes in absolute paths.
                  '';

                  type = lib.types.listOf (lib.types.either lib.types.str (lib.types.submodule {
                    options = {
                      directory = lib.mkOption {
                        type = lib.types.str;
                        example = "/home/username/.config/nvim";
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
          # }}}
        };
      }));
    };
  };
  # }}}
  # {{{ Config generation
  config =
    let
      makeLocation = location:
        let
          # {{{ Path processing
          processPath = appName: path:
            let
              suffix = "${lib.strings.removePrefix "${config.home.homeDirectory}/" (builtins.toString path)}";
              prefix = if location.prefixDirectories then "${appName}/" else "";
            in
            # lib.debug.traceSeq "\nProcessing path at location ${location.path} and app ${appName} from original path ${value} to ${prefix + suffix}"
            (prefix + suffix);
          # }}}
          # {{{ Constructors
          mkDirectory = appName: directory:
            if builtins.isAttrs directory then {
              method = directory.method;
              directory = processPath appName directory.directory;
            }
            else processPath appName directory;

          mkAppDirectory = app: builtins.map (mkDirectory app.name) app.directories;
          mkAppFiles = app: builtins.map (processPath app.name) app.files;
          # }}}
        in
        # {{{ Impermanence config generation
        lib.attrsets.nameValuePair location.home {
          removePrefixDirectory = location.prefixDirectories;
          allowOther = true;
          directories = lib.lists.flatten
            (lib.attrsets.mapAttrsToList (_: mkAppDirectory) location.apps);

          files = lib.lists.flatten
            (lib.attrsets.mapAttrsToList (_: mkAppFiles) location.apps);
        };
      # }}}
    in
    lib.mkIf cfg.enable {
      home.persistence = lib.attrsets.mapAttrs' (_: makeLocation) cfg.at;
    };
  # }}}
}
