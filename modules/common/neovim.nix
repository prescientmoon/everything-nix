# This module provides personalised helpers for managing plugins
# using lazy.nvim and a set of custom runtime primitives.
{ pkgs, lib, config, ... }:
let
  inherit (lib) types;

  e = config.satellite.lib.lua.encoders;
  cfg = config.satellite.neovim;

  # {{{ Custom types 
  myTypes = {
    oneOrMany = t: types.either t (types.listOf t);
    zeroOrMore = t: types.nullOr (myTypes.oneOrMany t);

    # {{{ Lua code 
    luaCode = types.nullOr (types.oneOf [
      types.str
      types.path
      myTypes.luaLiteral
    ]);

    luaLiteral = types.submodule {
      options.__luaEncoderTag = lib.mkOption {
        type = types.enum [ "lua" ];
      };
      options.value = lib.mkOption {
        type = types.str;
      };
    };

    luaValue = types.nullOr (types.oneOf [
      types.str
      types.number
      types.bool
      (types.attrsOf myTypes.luaValue)
      (types.listOf myTypes.luaValue)
    ]);
    # }}}
    # {{{ Lazy key
    lazyKey = types.oneOf [
      types.str
      (types.submodule
        {
          options.mapping = lib.mkOption {
            type = types.str;
            description = "The lhs of the neovim mapping";
          };

          options.action = lib.mkOption {
            default = null;
            type = types.nullOr (types.oneOf [
              types.str
              myTypes.luaLiteral
            ]);
            description = "The rhs of the neovim mapping";
          };

          options.ft = lib.mkOption {
            default = null;
            type = myTypes.zeroOrMore types.str;
            description = "Filetypes on which this keybind should take effect";
          };

          options.mode = lib.mkOption {
            default = null;
            type = types.nullOr types.str;
            description = "The vim modes the mapping should take effect in";
          };

          options.desc = lib.mkOption {
            default = null;
            type = types.nullOr types.str;
            description = "Description for the current keymapping";
          };
        })
    ];
    # }}} 
    # {{{ Tempest key
    tempestKey = types.submodule {
      options = {
        mapping = lib.mkOption {
          example = "<leader>a";
          type = types.str;
          description = "The lhs of the neovim mapping";
        };

        action = lib.mkOption {
          example = "<C-^>";
          type = types.either types.str myTypes.luaLiteral;
          description = "The rhs of the neovim mapping";
        };

        bufnr = lib.mkOption {
          default = null;
          example = true;
          type = types.nullOr
            (types.oneOf [
              types.bool
              types.integer
              myTypes.luaLiteral
            ]);
          description = ''
            The index of the buffer to apply local keymaps to. Can be set to 
            `true` to refer to the current buffer
          '';
        };

        mode = lib.mkOption {
          default = null;
          example = "nov";
          type = types.nullOr types.str;
          description = "The vim modes the mapping should take effect in";
        };

        silent = lib.mkOption {
          default = null;
          example = true;
          type = types.nullOr types.bool;
          description = "Whether the logs emitted by the keymap should be supressed";
        };

        expr = lib.mkOption {
          default = null;
          example = true;
          type = types.nullOr types.bool;
          description = "If set to `true`, the mapping is treated as an action factory";
        };

        desc = lib.mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "Description for the current keymapping";
        };
      };
    };
    # }}}
    # {{{ Tempest autocmd
    tempestAutocmd = types.submodule {
      options = {
        event = lib.mkOption {
          example = "InsertEnter";
          type = myTypes.oneOrMany types.str;
          description = "Events to bind autocmd to";
        };

        pattern = lib.mkOption {
          example = "Cargo.toml";
          type = myTypes.oneOrMany types.str;
          description = "File name patterns to run autocmd on";
        };

        group = lib.mkOption {
          example = "CargoCmpSource";
          type = types.str;
          description = "Name of the group to create and assign autocmd to";
        };

        action = lib.mkOption {
          example.vim.opt.cmdheight = 1;
          type = types.oneOf [
            myTypes.tempestConfiguration
            myTypes.luaCode
          ];
          description = ''
            Code to run when the respctive event occurs. Will pass the event
            object as context, which might be used for things like assigning 
            a buffer number to local keymaps automatically.
          '';
        };
      };
    };
    # }}}
    # {{{ Tempest configuration
    tempestConfiguration = types.submodule {
      options = {
        vim = lib.mkOption {
          default = null;
          type = myTypes.luaValue;
          example.opt.cmdheight = 0;
          description = "Values to assign to the `vim` lua global object";
        };

        keys = lib.mkOption {
          default = null;
          type = myTypes.zeroOrMore myTypes.tempestKey;
          description = ''
            Arbitrary key mappings to create. The keymappings might 
            automatically be buffer specific depending on the context. For 
            instance, keymappings created inside autocmds will be local unless
            otherwise specified.
          '';
        };

        autocmds = lib.mkOption {
          default = null;
          type = myTypes.zeroOrMore myTypes.tempestAutocmd;
          description = "Arbitrary autocmds to create";
        };

        setup = lib.mkOption {
          default = null;
          type = types.nullOr (types.attrsOf myTypes.luaValue);
          example.lualine.opts.theme = "auto";
          description = ''
            Key-pair mappings for options to pass to .setup functions imported
            from different modules
          '';
        };

        callback = lib.mkOption {
          default = null;
          type = types.nullOr myTypes.luaCode;
          description = "Arbitrary code to run after everything else has been configured";
        };
      };
    };
    # }}}
    # {{{ Lazy module
    lazyModule = lib.fix (lazyModule: types.submodule ({ name ? null, ... }: {
      options = {
        package = lib.mkOption {
          default = null;
          type = types.nullOr types.str;
          description = "Package to configure the module around";
          example = "nvim-telescope/telescope.nvim";
        };

        dir = lib.mkOption {
          default = null;
          type = types.nullOr types.path;
          description = "Path to install pacakge from";
        };

        name = lib.mkOption {
          default = name;
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
          type = types.listOf (types.either types.str lazyModule);
          description = "Lazy.nvim module dependencies";
        };

        dependencies.nix = lib.mkOption {
          default = [ ];
          type = types.listOf types.package;
          description = "Nix packages to give nvim access to";
        };

        cond = lib.mkOption {
          default = null;
          type = myTypes.luaCode;
          description = "Condition based on which to enable/disbale loading the package";
        };

        env.blacklist = lib.mkOption {
          default = [ ];
          type = types.listOf (types.enum [ "firenvim" "vscode" "neovide" ]);
          description = "Environments to blacklist plugin on";
        };

        setup = lib.mkOption {
          default = null;
          type = types.nullOr (types.oneOf [
            myTypes.tempestConfiguration
            myTypes.luaCode
            types.bool
          ]);
          description = ''
            Lua function (or module) to use for configuring the package.
            Used instead of the canonically named `config` because said name has a special meaning in nix
          '';
        };

        event = lib.mkOption {
          default = null;
          type = myTypes.zeroOrMore types.str;
          description = "Event on which the module should be lazy loaded";
        };

        ft = lib.mkOption {
          default = null;
          type = myTypes.zeroOrMore types.str;
          description = "Filetypes on which the module should be lazy loaded";
        };

        cmd = lib.mkOption {
          default = null;
          type = myTypes.zeroOrMore types.str;
          description = "Comands on which to load this plugin";
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
          type = myTypes.zeroOrMore myTypes.lazyKey;
          description = "Keybinds to lazy-load the module on";
        };
      };
    }));
    # }}}
  };
  # }}}
in
{
  # {{{ Option declaration 
  options.satellite.neovim = {
    lazy = lib.mkOption {
      default = { };
      description = "Record of plugins to install using lazy.nvim";
      type = types.attrsOf myTypes.lazyModule;
    };

    # {{{ Generated
    generated = {
      lazy = lib.mkOption {
        type = types.attrsOf (types.submodule {
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
        });
        description = "Attrset containing every module generated from the lazy configuration";
      };

      all = lib.mkOption {
        default = { };
        type = types.package;
        description = "Derivation building all the given nix modules";
      };

      lazySingleFile = lib.mkOption {
        type = types.package;
        description = "Derivation building all the given nix modules in a single file";
      };

      dependencies = lib.mkOption {
        default = [ ];
        type = types.listOf types.package;
        description = "List of packages to give neovim access to";
      };
    };
    # }}}
    # {{{ Lua generation lib 
    lib = {
      # {{{ Basic lua generators
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
      # }}}
      # {{{ Encoders 
      encode = lib.mkOption {
        default = e.anything;
        type = types.functionTo types.str;
        description = "Encode a nix value to a lua string";
      };

      encodeTempestConfiguration = lib.mkOption {
        default = given:
          e.attrset true [ ]
            {
              vim = e.anything;
              callback = e.nullOr e.luaString;
              setup = e.nullOr (e.attrsetOf e.anything);
              keys = e.zeroOrMany (e.attrset true [ ] {
                mapping = e.string;
                action = e.luaCodeOr e.string;
                desc = e.nullOr e.string;
                expr = e.nullOr e.bool;
                mode = e.nullOr e.string;
                silent = e.nullOr e.bool;
                buffer = e.nullOr (e.luaCodeOr (e.boolOr e.number));
              });
              autocmds = e.zeroOrMany (e.attrset true [ ] {
                event = e.oneOrMany e.string;
                pattern = e.oneOrMany e.string;
                group = e.string;
                action = e.conditional lib.isAttrs
                  cfg.lib.encodeTempestConfiguration
                  e.luaString;
              });
            }
            given;
        type = types.functionTo types.str;
        description = "Generate a lua object for passing to my own lua runtime for configuration";
      };
      # }}}
      # {{{ Thunks
      # This version of `nlib.thunk` is required in ceratain cases because 
      # of issues with `types.oneOf [types.submodule ..., types.submodule]` not
      # working as intended atm.
      thunkString = lib.mkOption {
        default = given: /* lua */ ''
          function() ${e.luaString given} end
        '';
        type = types.functionTo types.str;
        description = "Wrap a lua expression into a lua function as a string";
      };

      thunk = lib.mkOption {
        default = given: cfg.lib.lua (cfg.lib.thunkString given);
        type = types.functionTo myTypes.luaLiteral;
        description = "Wrap a lua expression into a lua function";
      };


      contextThunk = lib.mkOption {
        default = given: cfg.lib.lua /* lua */ ''
          function(context) ${e.luaString given} end
        '';
        type = types.functionTo myTypes.luaLiteral;
        description = "Wrap a lua expression into a lua function taking an argument named `context`";
      };
      # }}}
      # {{{ Language server on attach
      languageServerOnAttach = lib.mkOption {
        default = given: cfg.lib.lua /* lua */ ''
          function(client, bufnr)
            require(${e.string cfg.runtime.tempest}).configure(${cfg.lib.encodeTempestConfiguration given}, 
              { client = client; bufnr = bufnr; })

            require(${e.string cfg.runtime.languageServerOnAttach}).on_attach(client, bufnr)
          end
        '';
        type = types.functionTo myTypes.luaCode;
        description = "Attach a language server and run some additional code";
      };
      # }}}
    };
    # }}}
    # {{{ Neovim runtime module paths
    runtime = {
      env = lib.mkOption {
        type = types.str;
        example = "my.helpers.env";
        description = "Module to import env flags from";
      };

      tempest = lib.mkOption {
        type = types.str;
        example = "my.runtime.tempest";
        description = "Module to import the tempest runtime from";
      };

      languageServerOnAttach = lib.mkOption {
        type = types.str;
        example = "my.runtime.lspconfig";
        description = "Module to import langauge server .on_attach function from";
      };
    };
    # }}}
  };
  # }}}
  # {{{ Config generation 
  # {{{ Lazy module generation 
  config.satellite.neovim.generated.lazy =
    let
      # {{{ Lazy key encoder
      lazyKeyEncoder =
        e.stringOr (e.attrset true [ "mapping" "action" ] {
          mapping = e.string;
          action = e.nullOr (e.luaCodeOr e.string);
          mode = e.nullOr
            (e.map
              lib.strings.stringToCharacters
              (e.listAsOneOrMany e.string));
          desc = e.nullOr e.string;
          ft = e.zeroOrMany e.string;
        });
      # }}}
      # {{{ Lazy spec encoder 
      xor = a: b: (a || b) && (!a || !b);
      implies = a: b: !a || b;
      hasProp = obj: p: (obj.${p} or null) != null;
      propXor = a: b: obj: xor (hasProp obj a) (hasProp obj b);
      propImplies = a: b: obj: implies (hasProp obj a) (hasProp obj b);

      lazyObjectEncoder = e.bind
        (opts: e.attrset true [ "package" ]
          {
            package = e.nullOr e.string;
            dir = assert propXor "package" "dir" opts; e.nullOr e.string;
            tag = assert propImplies "tag" "package" opts; e.nullOr e.string;
            version = assert propImplies "tag" "package" opts; e.nullOr e.string;
            name = e.nullOr e.string;
            main = e.nullOr e.string;
            dependencies = e.map (d: d.lua) (e.tryNonemptyList (e.stringOr lazyObjectEncoder));
            lazy = e.nullOr e.bool;
            cond = e.conjunction
              (e.nullOr (e.luaCode "cond"))
              (e.filter (_: opts.env.blacklist != [ ])
                (e.const /* lua */ ''
                  require(${e.string cfg.runtime.env}).blacklist(${e.listOf e.string opts.env.blacklist})
                ''));

            config = _:
              let
                wrap = given: /* lua */''
                  function(lazy, opts)
                    require(${e.string cfg.runtime.tempest}).configure(${given}, 
                      { lazy = lazy; opts = opts; })
                  end
                '';
              in
              e.conditional lib.isAttrs
                (e.postmap wrap cfg.lib.encodeTempestConfiguration)
                (e.nullOr (e.boolOr (e.luaCode "config")))
                opts.setup;
            init = e.nullOr (e.luaCode "init");
            event = e.zeroOrMany e.string;
            cmd = e.zeroOrMany e.string;
            ft = e.zeroOrMany e.string;
            keys = e.nullOr (e.oneOrManyAsList lazyKeyEncoder);
            passthrough = e.anything;
            opts = e.anything;
          });
      # }}}
    in
    lib.attrsets.mapAttrs
      (name: opts: rec {
        raw = lazyObjectEncoder opts;
        module = config.satellite.lib.lua.writeFile "lua/nix/plugins" name raw;
      })
      cfg.lazy;

  config.satellite.neovim.generated.lazySingleFile =
    let
      makeFold = name: m: ''
        -- {{{ ${name}
        ${m.raw},
        -- }}}'';

      mkReturnList = objects: ''
        return {
          ${objects}
        }'';

      script = lib.pipe cfg.generated.lazy [
        (lib.attrsets.mapAttrsToList makeFold)
        (lib.concatStringsSep "\n")
        mkReturnList
      ];
    in
    config.satellite.lib.lua.writeFile
      "lua/nix/plugins" "init"
      script;

  config.satellite.neovim.generated.all =
    pkgs.symlinkJoin {
      name = "lazy-nvim-modules";
      paths = lib.attrsets.mapAttrsToList (_: m: m.module) cfg.generated.lazy;
    };
  # }}}

  config.satellite.neovim.generated.dependencies =
    lib.pipe cfg.lazy
      [
        (lib.attrsets.mapAttrsToList (_: m: m.dependencies.nix))
        lib.lists.flatten
      ];
  # }}}
}
