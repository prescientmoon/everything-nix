# Additional theming primitives not provided by stylix
{ pkgs, lib, config, ... }:
let
  inherit (lib) types;

  cfg = config.satellite.neovim;

  # {{{ Custom types 
  myTypes = {
    luaCode = types.nullOr (types.oneOf [
      types.str
      types.path
    ]);

    fileTypes = types.nullOr (types.oneOf [
      types.str
      (types.listOf types.str)
    ]);

    # {{{ Key type
    lazyKey = types.oneOf [
      types.str
      (types.submodule
        (_: {
          options.mapping = lib.mkOption {
            type = types.str;
          };

          options.action = lib.mkOption {
            type = types.str;
          };

          options.ft = lib.mkOption {
            default = null;
            type = myTypes.fileTypes;
            description = "Filetypes on which this keybind should take effect";
          };

          options.mode = lib.mkOption {
            default = null;
            # Only added the types I'm using in my config atm
            type = types.nullOr (types.enum [ "n" "v" ]);
          };

          options.desc = lib.mkOption {
            default = null;
            type = types.nullOr types.str;
          };
        }))
    ];
    # }}} 
    # {{{ Lazy module type 
    lazyModule = lib.fix (lazyModule: types.submodule (_: {
      options = {
        package = lib.mkOption {
          type = types.oneOf [
            types.package
            types.str
          ];
          description = "Package to configure the module around";
          example = "nvim-telescope/telescope.nvim";
        };

        version = lib.mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "Pin the package to a certain version (useful for non-nix managed packages)";
        };

        tag = lib.mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "Pin the package to a certain git tag (useful for non-nix managed packages)";
        };

        lazy = lib.mkOption {
          default = null;
          type = types.nullOr types.bool;
          description = "Specifies whether this module should be lazy-loaded";
        };

        dependencies.lua = lib.mkOption {
          default = [ ];
          type = types.listOf lazyModule;
        };

        dependencies.nix = lib.mkOption {
          default = [ ];
          type = types.listOf types.package;
        };

        cond = lib.mkOption {
          default = null;
          type = myTypes.luaCode;
          description = "Condition based on which to enable/disbale loading the package";
        };

        setup = lib.mkOption {
          default = null;
          type = types.oneOf [ myTypes.luaCode types.bool ];
          description = ''
            Lua function (or module) to use for configuring the package.
            Used instead of the canonically named `config` because said property has a special name in nix'';
        };

        event = lib.mkOption {
          default = null;
          type = types.nullOr (types.oneOf [
            types.str
            (types.listOf types.str)
          ]);
          description = "Event on which the module should be lazy loaded";
        };

        ft = lib.mkOption {
          default = null;
          type = myTypes.fileTypes;
          description = "Filetypes on which the module should be lazy loaded";
        };

        init = lib.mkOption {
          default = null;
          type = myTypes.luaCode;
          description = "Lua function (or module) to run right away (even if the package is not yet loaded)";
        };

        passthrough = lib.mkOption {
          default = null;
          type = myTypes.luaCode;
          description = "Attach additional things to the lazy module";
        };

        keys = lib.mkOption {
          default = null;
          type =
            types.nullOr (types.oneOf [
              myTypes.lazyKey
              (types.listOf myTypes.lazyKey)
            ]);
        };

        opts = { };
      };
    }));
    # }}}
  };
  # }}}
  # {{{ Lua encoders
  mkRawLuaObject = chunks:
    ''
      {
        ${lib.concatStringsSep "," (lib.filter (s: s != "") chunks)}
      }
    '';

  # An encoder is a function from some nix value to a string containing lua code. 
  # This object provides combinators for writing such encoders.
  luaEncoders = {
    # {{{ General helpers 
    identity = given: given;
    bind = encoder: given: encoder given given;
    conditional = predicate: caseTrue: caseFalse:
      luaEncoders.bind (given: if predicate given then caseTrue else caseFalse);
    map = f: encoder: given: encoder (f given);
    trace = message: luaEncoders.map (f: lib.traceSeq message f);
    # }}}
    # {{{ Base types
    # TODO: figure out escaping and whatnot
    string = string: ''"${string}"'';
    bool = bool: if bool then "true" else "false";
    nil = _: "nil";
    stringOr = luaEncoders.conditional lib.isString luaEncoders.string;
    boolOr = luaEncoders.conditional lib.isBool luaEncoders.bool;
    nullOr = luaEncoders.conditional (e: e == null) luaEncoders.nil;
    # }}}
    # {{{ Advanced types
    luaCode = tag:
      luaEncoders.conditional lib.isPath
        (path: "require(${path}).${tag}")
        luaEncoders.identity;

    listOf = encoder: list:
      mkRawLuaObject (lib.lists.map encoder list);
    tryNonemptyList = encoder: luaEncoders.conditional
      (l: l == [ ])
      luaEncoders.nil
      (luaEncoders.listOf encoder);
    oneOrMany = encoder:
      luaEncoders.conditional
        lib.isList
        (luaEncoders.listOf encoder)
        encoder;
    oneOrManyAsList = encoder: luaEncoders.map
      (given: if lib.isList given then given else [ given ])
      (luaEncoders.listOf encoder);

    attrset = noNils: listOrder: listSpec: spec: attrset:
      let
        shouldKeep = given:
          if noNils then
            given != "nil"
          else
            true;

        listChunks = lib.lists.map
          (attr:
            let result = listSpec.${attr} (attrset.${attr} or null);
            in
            lib.optionalString (shouldKeep result) result
          )
          listOrder;
        objectChunks = lib.mapAttrsToList
          (attr: encoder:
            let result = encoder (attrset.${attr} or null);
            in
            lib.optionalString (shouldKeep result)
              "${attr} = ${result}"
          )
          spec;
      in
      mkRawLuaObject (listChunks ++ objectChunks);
    # }}}
  };

  e = luaEncoders;
  # }}}

  # Format and write a lua file to disk
  writeLuaFile = path: name: text:
    let
      directory = "lua/${path}";
      destination = "${directory}/${name}.lua";
      unformatted = pkgs.writeText "raw-lua-${name}" text;
    in
    pkgs.runCommand "formatted-lua-${name}" { } ''
      mkdir -p $out/${directory}
      cp --no-preserve=mode ${unformatted} $out/${destination}
      ${lib.getExe pkgs.stylua} --config-path ${cfg.styluaConfig} $out/${destination}
    '';
in
{
  options.satellite.neovim = {
    lazy = lib.mkOption {
      default = { };
      description = "Record of persistent locations (eg: /persist)";
      type = types.attrsOf myTypes.lazyModule;
    };

    generated.lazy = lib.mkOption {
      type = types.attrsOf (types.submodule (_: {
        options = {
          raw = lib.mkOption {
            type = types.lines;
            description = "The lua script generated using the other options";
          };

          module = lib.mkOption {
            type = types.package;
            description = "The lua script generated using the other options";
          };
        };
      }));
      description = "Attrset containing every module generated from the lazy configuration";
    };

    generated.all = lib.mkOption {
      default = { };
      type = types.package;
      description = "Derivation building all the given nix modules";
    };

    styluaConfig = lib.mkOption {
      type = types.path;
      description = "Config to use for formatting lua modules";
    };
  };

  config.satellite.neovim.generated.lazy =
    let
      lazyKeyEncoder =
        e.stringOr (e.attrset true [ "mapping" "action" ]
          {
            mapping = e.string;
            action = e.nullOr e.string;
          }
          {
            mode = e.nullOr e.string;
            desc = e.nullOr e.string;
            ft = e.nullOr (e.oneOrMany e.string);
          });

      renameKey = from: to: lib.mapAttrs' (name: value:
        if name == from then { inherit value; name = to; }
        else { inherit name value; });


      lazyObjectEncoder = e.map (renameKey "setup" "config")
        (e.attrset true [ "package" ]
          {
            package = e.string;
          }
          {
            tag = e.nullOr e.string;
            version = e.nullOr e.string;
            dependencies = e.map (d: d.lua) (e.tryNonemptyList lazyObjectEncoder);
            lazy = e.nullOr e.bool;
            # TODO: add sugar for enabling/disabling under certain envs
            cond = e.nullOr (e.luaCode "cond");
            config = e.nullOr (e.boolOr (e.luaCode "config"));
            init = e.nullOr (e.luaCode "init");
            event = e.nullOr (e.oneOrMany e.string);
            ft = e.nullOr (e.oneOrMany e.string);
            keys = e.nullOr (e.oneOrManyAsList lazyKeyEncoder);
            # TODO: passthrough
          });

      makeLazyScript = opts: ''
        -- This file was generated by nix
        return ${lazyObjectEncoder opts}
      '';
    in
    lib.attrsets.mapAttrs
      (name: opts: rec {
        raw = makeLazyScript opts;
        module = writeLuaFile "nix/plugins" name raw;
      })
      cfg.lazy;

  config.satellite.neovim.generated.all =
    pkgs.symlinkJoin {
      name = "lazy-nvim-modules";
      paths = lib.attrsets.mapAttrsToList (_: m: m.module) cfg.generated.lazy;
    };
}
