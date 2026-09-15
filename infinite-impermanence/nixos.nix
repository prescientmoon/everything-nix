{
  pkgs,
  config,
  options,
  lib,
  utils,
  ...
}:
let
  elib = pkgs.callPackage ./lib.nix { };
  cfg = config.satellite.persistence;
  outerConfig = config;

  # {{{ All persistent storage path values zipped together into one set.
  mergeBinds =
    mod:
    lib.zipAttrsWith (_: lib.flatten) (
      [ { inherit (mod) directories files scaffolding; } ] # .
      ++ lib.mapAttrsToList (_: mergeBinds) mod.at
    );

  everything =
    let
      # All enabled system paths
      nixos = mergeBinds cfg;

      # Fetch enabled paths from all Home Manager users who have the
      # persistence module loaded
      homeManager = lib.mapAttrsToList (
        _: u: mergeBinds (u.satellite.persistence or { })
      ) config.home-manager.users or { };
    in
    lib.zipAttrsWith (_: lib.flatten) ([ nixos ] ++ homeManager);
  # }}}
in
{
  # {{{ Options
  options.satellite.persistence = lib.mkOption {
    type = lib.types.submodule [
      { options.enable = lib.mkEnableOption "infinite impermanence"; }
      (lib.modules.importApply ./submodule.nix { inherit pkgs lib; })
      {
        permissions.mode = lib.mkDefault "755";
        permissions.user = lib.mkDefault "root";
        permissions.group = lib.mkDefault "root";
        bounds.target = lib.mkDefault "/";
        bounds.source = lib.mkDefault "/";
        autoScaffold = false;
      }
    ];
  };
  # }}}

  config = lib.mkMerge [
    # {{{ Home manager setup
    (lib.optionalAttrs (options ? home-manager.sharedModules) {
      home-manager.sharedModules = [
        {
          options.satellite.persistence = lib.mkOption {
            type = lib.types.submodule [
              (lib.modules.importApply ./submodule.nix { inherit pkgs lib; })
              (
                { config, ... }:
                let
                  user =
                    lib.findFirst (u: u.name == config.home.username)
                      (throw "Cannot find user with name ${config.home.username}")
                      (lib.attrValues outerConfig.users.users);
                in
                {
                  permissions.user = user.name;
                  permissions.group = user.group;
                  permissions.mode = user.homeMode;
                  bounds.target = user.home;
                  bounds.source = lib.mkDefault "/";
                  autoScaffold = false;
                }
              )
            ];
          };
        }
      ];
    })
    # }}}
    (lib.mkIf cfg.enable {
      # {{{ Create file mounting services
      systemd.services =
        let
          mountFile = pkgs.writers.writePython3 "ii-mount-file" {
            doCheck = false;
          } ./mount-file.py;

          mkPersistFileService =
            args:
            let
              escaped = utils.escapeSystemdPath args.paths.source;
            in
            {
              "persist-${escaped}" = {
                unitConfig.DefaultDependencies = false;
                description = "Bind mount or link ${args.paths.source} to ${args.paths.target}";
                wantedBy = [ "local-fs.target" ];
                before = [ "local-fs.target" ];
                path = [ pkgs.util-linux ];
                serviceConfig = {
                  Type = "oneshot";
                  RemainAfterExit = true;
                  ExecStart = "${mountFile} ${
                    lib.escapeShellArgs [
                      args.paths.source
                      args.paths.target
                      args.permissions.mode
                    ]
                  }";
                  ExecStop = pkgs.writeShellScript "unbindOrUnlink-${escaped}" ''
                    set -eu
                    if [[ ! -L ${args.paths.target} ]]; then
                      umount ${args.paths.target}
                    fi
                    rm ${args.paths.target}
                  '';
                };
              };
            };
        in
        lib.mkMerge (lib.forEach everything.files mkPersistFileService);
      # }}}
      # {{{ Set up boot-time mounts
      boot.initrd.systemd.mounts =
        let
          dirs = lib.filter (d: lib.elem d.paths.target utils.pathsNeededForBoot) everything.directories;
        in
        lib.forEach dirs (args: {
          unitConfig.DefaultDependencies = false;
          wantedBy = [ "initrd.target" ];
          before = [ "initrd-nixos-activation.service" ];
          where = elib.concatPaths [
            "/sysroot"
            args.paths.target
          ];
          what = elib.concatPaths [
            "/sysroot"
            args.paths.source
          ];
          type = "none";
          options = "bind,x-gvfs-hide";
        });
      # }}}
      # {{{ Set up runtime mounts
      systemd.mounts = lib.forEach everything.directories (args: {
        unitConfig.DefaultDependencies = false;
        wantedBy = [ "local-fs.target" ];
        before = [ "local-fs.target" ];
        where = args.paths.target;
        what = args.paths.source;
        type = "none";
        options = "bind,x-gvfs-hide";
      });
      # }}}
      # {{{ Scaffolding
      system.activationScripts.impermanenceScaffolding = {
        deps = [
          "users"
          "groups"
        ];
        text =
          let
            pyScript = pkgs.writers.writePython3 "ii-directories" {
              doCheck = false;
            } ./directories.py;

            entries = everything.scaffolding;
            jsonConfig = pkgs.writeText "paths.json" (builtins.toJSON entries);
          in
          "${pyScript} ${jsonConfig}";
      };
      # }}}
      # {{{ Assertions
      assertions = [
        {
          assertion = config.boot.initrd.systemd.enable;
          message = "Non-stystemd initrd is not supported";
        }
      ];
      # }}}
    })
  ];
}
