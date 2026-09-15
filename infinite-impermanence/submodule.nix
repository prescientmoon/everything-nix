{ pkgs, lib }:
lib.fix (
  self:
  { config, ... }:
  let
    elib = pkgs.callPackage ./lib.nix { };
    outerConfig = config;

    # {{{ Bounds options
    boundsOpts.options = {
      source = lib.mkOption {
        type = lib.types.path;
        default = outerConfig.bounds.source;
        description = ''
          The path to persistent storage where the real file or directory
          should be stored.
        '';
      };

      target = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = outerConfig.bounds.target;
        description = ''
          The path to the home directory the file or directory should be
          stored within.
        '';
      };
    };
    # }}}
    # {{{ Permission options
    userGroupOpts.options = {
      user = lib.mkOption {
        type = lib.types.str;
        example = "root";
        default = config.permissions.user;
      };

      group = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        example = "users";
        default = config.permissions.group;
      };
    };

    permissionOpts.options = {
      mode = lib.mkOption {
        type = lib.types.str;
        example = "0700";
      };
    }
    // userGroupOpts.options;
    # }}}
    # {{{ Common options
    commonOpts =
      { config, ... }:
      let
        noPrefix = lib.removePrefix config.bounds.target config.base;
      in
      {
        options = permissionOpts.options // {
          base = lib.mkOption {
            type = lib.types.pathWith { absolute = null; };
            description = ''
              The initially configured path from the user. The remaining
              paths are automatically derived from this.
            '';
          };

          bounds = boundsOpts.options;

          paths.source = lib.mkOption {
            type = lib.types.path;
            description = "The path of the file in the persisten volume.";
            default = elib.concatPaths [
              config.bounds.source
              noPrefix
            ];
          };

          paths.target = lib.mkOption {
            type = lib.types.path;
            description = "The path of the file in the ephemeral volume.";
            default = elib.concatPaths [
              config.bounds.target
              noPrefix
            ];
          };
        };
      };
    # }}}
    # {{{ Files
    fileOpts =
      { config, ... }:
      {
        options.parent = lib.mkOption {
          type = lib.types.submodule permissionOpts;
          description = ''
            The permissions to be used when creating the parent directory.
            These are separate because most files need not be executable, yet
            most directories do. Also note that the current implementation is
            pretty loose when it comes to file permissions, and they might
            therefore get ignored (especially if the file does not exist at the
            time of the symlink's creation).
          '';
        };

        config.mode = lib.mkDefault "644";
        config.parent = {
          user = lib.mkDefault config.user;
          group = lib.mkDefault config.group;
          mode = lib.mkDefault "755";
        };
      };

    file = lib.types.submodule [
      commonOpts
      fileOpts
    ];
    # }}}
    # {{{ Directories
    dir = lib.types.submodule [
      commonOpts
      { config.mode = lib.mkDefault "755"; }
    ];
    # }}}
    # {{{ Nesting option
    nest =
      args:
      lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule [
            self
            (
              { name, config, ... }:
              {
                permissions = {
                  mode = lib.mkDefault outerConfig.permissions.mode;
                  user = lib.mkDefault outerConfig.permissions.user;
                  group = lib.mkDefault outerConfig.permissions.group;
                };

                bounds = {
                  target = lib.mkDefault (
                    if args.target then
                      elib.concatPaths [
                        outerConfig.bounds.target
                        name
                      ]
                    else
                      outerConfig.bounds.target
                  );
                  source = lib.mkDefault (
                    if args.source then
                      elib.concatPaths [
                        outerConfig.bounds.source
                        name
                      ]
                    else
                      outerConfig.bounds.source
                  );
                };

                scaffolding = lib.mkIf outerConfig.autoScaffold [
                  {
                    inherit (config.permissions) user group mode;
                    path = config.bounds.source;
                    bound = outerConfig.bounds.source;
                  }
                  {
                    inherit (config.permissions) user group mode;
                    path = config.bounds.target;
                    bound = outerConfig.bounds.target;
                  }
                ];
              }
            )
          ]
        );
      };
    # }}}

    fromSource = base: { inherit base; };
  in
  {
    options = {
      # {{{ Base options
      files = lib.mkOption {
        type = lib.types.listOf (lib.types.coercedTo lib.types.str fromSource file);
        default = [ ];
        description = "Files that should be stored in persistent storage.";
      };

      directories = lib.mkOption {
        type = lib.types.listOf (lib.types.coercedTo lib.types.str fromSource dir);
        default = [ ];
        description = "Directories to bind mount to persistent storage.";
      };

      permissions = lib.mkOption {
        type = lib.types.submodule permissionOpts;
        description = ''
          The default user/group for directories. The given user/group/mode
          will also be used when auto-scaffolding nested target bounds.
        '';
      };

      bounds = lib.mkOption {
        type = lib.types.submodule boundsOpts;
        description = "The default bounds for files/directories.";
      };

      autoScaffold = lib.mkOption {
        type = lib.types.bool;
        default = true;
        internal = true;
        defaultText = "false for the root module, true otherwise";
        description = ''
          When true, the scaffolding for children modules (the one defined via
          the `at` property) is automatically generated from the given bounds
          and permissions.
        '';
      };
      # }}}
      # {{{ Scaffolding
      scaffolding = lib.mkOption {
        default = [ ];
        description = ''
          A list of directory that must be created. The parents are also
          recursively created until hitting the given upper "bound". The
          appropriate permisisons are set for each traversed directory.
        '';
        type = lib.types.listOf (
          lib.types.submodule [
            permissionOpts
            (
              { config, ... }:
              {
                options = {
                  path = lib.mkOption {
                    type = lib.types.path;
                    description = "The directory to create.";
                  };

                  bound = lib.mkOption {
                    type = lib.types.path;
                    description = ''
                      The directory at which to stop creating/managing parents at.
                    '';
                    default = dirOf config.path;
                    defaultText = "The given path's parent directory.";
                  };
                };
              }
            )
          ]
        );
      };
      # }}}
      # {{{ Nesting
      at = nest {
        source = true;
        target = false;
      };
      by = nest {
        source = false;
        target = true;
      };
      on = nest {
        source = true;
        target = true;
      };
      # }}}
    };

    # {{{ Entry scaffolding
    config.scaffolding =
      lib.map (entry: {
        inherit (entry.parent) user group mode;
        path = dirOf entry.paths.source;
        bound = entry.bounds.source;
      }) config.files
      ++ lib.map (entry: {
        inherit (entry) user group mode;
        path = entry.paths.source;
        bound = entry.bounds.source;
      }) config.directories
      ++ lib.map (entry: {
        inherit (entry.parent) user group mode;
        path = dirOf entry.paths.target;
        bound = entry.bounds.target;
      }) config.files
      ++ lib.map (entry: {
        inherit (entry) user group mode;
        path = entry.paths.target;
        bound = entry.bounds.target;
      }) config.directories;
    # }}}
  }
)
