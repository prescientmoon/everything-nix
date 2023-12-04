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
      myTypes.luaLiteral
    ]);

    luaLiteral = types.submodule (_: {
      options.__luaEncoderTag = lib.mkOption {
        type = types.enum [ "lua" ];
      };
      options.value = lib.mkOption {
        type = types.str;
      };
    });

    luaValue = types.nullOr (types.oneOf [
      types.str
      types.number
      types.bool
      (types.attrsOf myTypes.luaValue)
      (types.listOf myTypes.luaValue)
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
            type = types.nullOr (types.oneOf [
              types.str
              myTypes.luaLiteral
            ]);
          };

          options.ft = lib.mkOption {
            default = null;
            type = myTypes.fileTypes;
            description = "Filetypes on which this keybind should take effect";
          };

          options.mode = lib.mkOption {
            default = null;
            type = types.nullOr types.str;
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

        name = lib.mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "Custom name to use for the module";
          example = "lualine";
        };

        main = lib.mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "The name of the lua entrypoint for the plugin (usually auto-detected)";
          example = "lualine";
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

        opts = lib.mkOption {
          default = null;
          type = myTypes.luaValue;
          description = "Custom data to pass to the plugin .setup function";
        };

        keys = lib.mkOption {
          default = null;
          type =
            types.nullOr (types.oneOf [
              myTypes.lazyKey
              (types.listOf myTypes.lazyKey)
            ]);
        };
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
    trace = message: luaEncoders.map (f: lib.traceSeq message (lib.traceVal f));
    fail = mkMessage: v: builtins.throw (mkMessage v);
    const = code: _: code;
    # }}}
    # {{{ Base types
    # TODO: figure out escaping and whatnot
    string = string: ''"${string}"'';
    bool = bool: if bool then "true" else "false";
    number = toString;
    nil = _: "nil";
    stringOr = luaEncoders.conditional lib.isString luaEncoders.string;
    boolOr = luaEncoders.conditional lib.isBool luaEncoders.bool;
    numberOr = luaEncoders.conditional (e: lib.isFloat e || lib.isInt e) luaEncoders.number;
    nullOr = luaEncoders.conditional (e: e == null) luaEncoders.nil;
    anything = lib.pipe (luaEncoders.fail (v: "Cannot figure out how to encode value ${builtins.toJSON v}")) [
      (luaEncoders.attrsetOfOr luaEncoders.anything)
      (luaEncoders.listOfOr luaEncoders.anything)
      luaEncoders.nullOr
      luaEncoders.boolOr
      luaEncoders.numberOr
      luaEncoders.stringOr
      luaEncoders.luaCodeOr # Lua code expressions have priority over attrsets
    ];
    # }}}
    # {{{ Lua code
    luaCode = tag:
      luaEncoders.luaCodeOr
        (luaEncoders.conditional lib.isPath
          (path: "dofile(${luaEncoders.string path}).${tag}")
          luaEncoders.identity);
    luaCodeOr =
      luaEncoders.conditional (e: lib.isAttrs e && (e.__luaEncoderTag or null) == "lua")
        (obj: obj.value);
    # }}}
    # {{{ Lists
    listOf = encoder: list:
      mkRawLuaObject (lib.lists.map encoder list);
    tryNonemptyList = encoder: luaEncoders.conditional
      (l: l == [ ])
      luaEncoders.nil
      (luaEncoders.listOf encoder);
    listOfOr = encoder:
      luaEncoders.conditional
        lib.isList
        (luaEncoders.listOf encoder);
    oneOrMany = encoder: luaEncoders.listOfOr encoder encoder;
    oneOrManyAsList = encoder: luaEncoders.map
      (given: if lib.isList given then given else [ given ])
      (luaEncoders.listOf encoder);
    listAsOneOrMany = encoder:
      luaEncoders.map
        (l: if lib.length l == 1 then lib.head l else l)
        (luaEncoders.oneOrMany encoder);
    # }}}
    # {{{ Attrsets
    attrsetOf = encoder: object:
      mkRawLuaObject (lib.mapAttrsToList
        (name: value:
          let result = encoder value;
          in
          lib.optionalString (result != "nil")
            "${name} = ${result}"
        )
        object
      );
    attrsetOfOr = of: luaEncoders.conditional lib.isAttrs (luaEncoders.attrsetOf of);
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
      directory =   "lua/${path}";
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

    generated = {
      lazy = lib.mkOption {
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

      all = lib.mkOption {
        default = { };
        type = types.package;
        description = "Derivation building all the given nix modules";
      };

      dependencies = lib.mkOption {
        default = [ ];
        type = types.listOf types.package;
        description = "List of packages to give neovim access to";
      };
    };

    lib = {
      lua = lib.mkOption {
        default = value: { inherit value; __luaEncoderTag = "lua"; };
        type = types.functionTo myTypes.luaLiteral;
        description = "include some raw lua code inside module configuration";
      };

      import = lib.mkOption {
        default = path: tag: cfg.lib.lua "dofile(${e.string path}).${tag}";
        type = types.functionTo (types.functionTo myTypes.luaLiteral);
        description = "import some identifier from some module";
      };

      blacklistEnv = lib.mkOption {
        default = given: cfg.lib.lua ''
          require(${e.string cfg.env.module}).blacklist(${e.listOf e.string given})
        '';
        type = types.functionTo myTypes.luaLiteral;
        description = "Generate a lazy.cond predicate which disables a module if one of the given envs is active";
      };
    };

    env = {
      module = lib.mkOption {
        type = types.str;
        example = "my.helpers.env";
        description = "Module where to import env flags from";
      };
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
            action = e.nullOr (e.luaCodeOr e.string);
          }
          {
            mode = e.nullOr
              (e.map
                lib.strings.stringToCharacters
                (e.listAsOneOrMany e.string));
            desc = e.nullOr e.string;
            ft = e.nullOr (e.oneOrMany e.string);
          });

      lazyObjectEncoder = e.bind
        (opts: e.attrset true [ "package" ]
          { package = e.string; }
          {
            name = e.nullOr e.string;
            main = e.nullOr e.string;
            tag = e.nullOr e.string;
            version = e.nullOr e.string;
            dependencies = e.map (d: d.lua) (e.tryNonemptyList lazyObjectEncoder);
            lazy = e.nullOr e.bool;
            cond = e.nullOr (e.luaCode "cond");
            config = e.const (e.nullOr (e.boolOr (e.luaCode "config")) opts.setup);
            init = e.nullOr (e.luaCode "init");
            event = e.nullOr (e.oneOrMany e.string);
            ft = e.nullOr (e.oneOrMany e.string);
            keys = e.nullOr (e.oneOrManyAsList lazyKeyEncoder);
            passthrough = e.anything;
            opts = e.anything;
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

  config.satellite.neovim.generated.dependencies =
    lib.pipe cfg.lazy
      [
        (lib.attrsets.mapAttrsToList (_: m: m.dependencies.nix))
        lib.lists.flatten
      ]
  ;
}
