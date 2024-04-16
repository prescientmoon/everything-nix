attrs@{ lib, korora, ... }:
let
  e = import ./korora-lua.nix attrs;
  k = korora;
  h = e.helpers;
  struct = name: props: verify: (k.struct name props).override {
    total = false;
    unknown = false;
    verify = h.mkVerify verify;
  };

  lazyType = name: mkType: k.typedef' name (v: (mkType true).verify v);

  types = {
    # {{{ Helper types
    oneOrMany = type: k.union [ type (k.listOf type) ];
    luaValue = k.any;
    strictLuaLiteral = (k.struct "lua literal" {
      value = k.string;
      __luaEncoderTag = k.enum "lua literal tag" [ "lua" ];
    }).override { unknown = false; };
    derivation = k.typedef "derivation" lib.isDerivation;
    path = k.typedef "path" lib.isPath;
    functionCheckedWith = arg: type:
      k.typedef'
        "${h.toPretty arg} -> ${type.name}"
        (f:
          if lib.isFunction f
          then type.verify (f arg)
          else "Expected function, but got ${h.toPretty f} instead");
    luaEagerOrLazy = type: k.union [ type (types.functionCheckedWith "" type) ];
    luaLiteral = types.luaEagerOrLazy types.strictLuaLiteral;
    # }}}
    # {{{ Lazy key 
    lazyKey = struct "lazy key"
      {
        mapping = k.string;
        action = k.union [ types.luaLiteral k.string ];
        mode = k.string;
        desc = k.string;
        expr = k.bool;
        ft = types.oneOrMany k.string;
      }
      [ (h.propExists "mapping") ];
    # }}}
    # {{{ Lazy module 
    lazyModule = lazyType "actually lazy lazy module" (_: struct "lazy module"
      {
        package = k.string;
        dir = k.union [ k.string types.derivation types.path ];
        version = k.string;
        tag = k.string;
        name = k.string;
        main = k.string;
        lazy = k.bool;
        dependencies = struct "lazy dependencies"
          {
            lua = k.listOf (k.union [ k.string types.lazyModule ]);
            nix = k.listOf types.derivation;
          }
          [ ];
        cond = types.oneOrMany types.luaLiteral;
        init = k.union [ types.luaLiteral types.tempestConfig ];
        config = k.union [ types.luaLiteral k.bool types.tempestConfig ];
        event = types.oneOrMany k.string;
        cmd = types.oneOrMany k.string;
        ft = types.oneOrMany k.string;
        keys = types.oneOrMany (k.union [ k.string types.lazyKey ]);
        passthrough = types.luaValue;
        opts = types.luaValue;
      }
      [
        (h.propOnlyOne [ "dir" "package" ])
        (h.propImplies "tag" "package")
        (h.propImplies "version" "package")
      ]);
    # }}}
    # {{{ Tempest key 
    tempestKey = struct "tempest key"
      {
        mapping = k.string;
        action = k.union [ types.luaLiteral k.string ];
        mode = k.string;
        desc = k.string;
        expr = k.bool;
        silent = k.bool;
        ft = types.oneOrMany k.string;
        buffer = k.union [ k.bool k.number types.luaLiteral ];
      }
      [
        (h.propExists "mapping")
        (h.propExists "action")
      ];
    # }}}
    # {{{ Tempest autocmd 
    tempestAutocmd = struct "tempest autocommand"
      {
        event = types.oneOrMany k.string;
        pattern = types.oneOrMany k.string;
        group = k.string;
        action = k.union [ types.tempestConfig types.luaLiteral ];
      }
      [
        (h.propExists "event")
        (h.propExists "group")
        (h.propExists "action")
      ];
    # }}}
    # {{{ Tempest config
    tempestConfig = lazyType "lazy tempest config" (_: struct "tempest config"
      {
        vim = types.luaValue;
        callback = k.union [ types.luaLiteral types.tempestConfig ];
        setup = k.attrsOf types.luaValue;
        keys = types.luaEagerOrLazy (types.oneOrMany types.tempestKey);
        autocmds = types.luaEagerOrLazy (types.oneOrMany types.tempestAutocmd);
        mkContext = types.luaValue;
        cond = types.oneOrMany types.luaLiteral;
      }
      [ ]);
    # }}}
    # {{{ Neovim env 
    neovimEnv = k.enum "neovim env"
      [ "neovide" "firenvim" "vscode" ];
    # }}}
    # {{{ Neovim config 
    neovimConfig = struct "neovim configuration"
      {
        pre = k.attrsOf types.tempestConfig;
        lazy = k.attrsOf types.lazyModule;
        post = k.attrsOf types.tempestConfig;
      } [ ];
    # }}}
  };

  hasType = type: value:
    let err = type.verify value; in
    lib.assertMsg (err == null) err;

  mkLib = { tempestModule }:
    assert hasType k.string tempestModule;
    rec {
      inherit (e) encode;
      # {{{ Common generation helpers 
      lua = value: assert hasType k.string value;
        { inherit value; __luaEncoderTag = "lua"; };
      importFrom = path: tag:
        assert lib.isPath path;
        assert hasType k.string tag;
        lua "dofile(${encode (toString path)}).${tag}";
      foldedList = value: assert hasType k.attrs value;
        { inherit value; __luaEncoderTag = "foldedList"; };
      thunk = code: _: lua code;
      tempest = given: context: lua ''
        D.tempest.configure(
          ${encode given},
          ${context}
        )
      '';
      tempestBufnr = given: context: lua ''
        D.tempest.configure(
          ${encode given},
          { bufnr = ${context}}
        )
      '';
      keymap = mode: mapping: action: desc:
        { inherit mode mapping action desc; };
      nmap = mapping: action: desc:
        { inherit mapping action desc; };
      unmap = mapping:
        { inherit mapping; action = "<nop>"; };
      blacklist = given:
        assert hasType (types.oneOrMany types.neovimEnv) given;
        lua /* lua */  ''
          D.tempest.blacklist(${encode given})
        '';
      whitelist = given:
        assert hasType (types.oneOrMany types.neovimEnv) given;
        lua /* lua */  ''
          D.tempest.whitelist(${encode given})
        '';
      # :p => expands path
      # :h => returns the head of the path
      notmp = lua ''vim.fn.expand("%:p:h") ~= "/tmp"'';
      # }}}
      # {{{ Main config generation entrypoint
      generateConfig = rawConfig:
        assert hasType types.neovimConfig rawConfig;
        let
          config = { lazy = { }; pre = { }; post = { }; } // rawConfig;
          collectNixDeps = lazyModule:
            if lazyModule ? dependencies then
              let
                nix = lazyModule.dependencies.nix or [ ];
                other = lib.pipe (lazyModule.dependencies.lua or [ ]) [
                  (lib.lists.map collectNixDeps)
                  lib.lists.flatten
                ];
              in
              nix ++ other
            else
              [ ];
          dependencies = lib.pipe config.lazy [
            (lib.mapAttrsToList (_: collectNixDeps))
            lib.lists.flatten
          ];
          processedLazyModules =
            lib.mapAttrs
              (name: module: { inherit name; } // module // {
                dependencies = (module.dependencies or { }).lua or null;
              })
              config.lazy;

          luaConfig = ''
            local M = {}
            local D = {
              tempest = require(${encode tempestModule}),
            }

            -- {{{ Pre-plugin config
            M.pre = ${encode (foldedList config.pre)}
            -- }}}
            -- {{{ Lazy modules 
            M.lazy = ${encode (foldedList processedLazyModules)}
            D.tempest.prepareLazySpec(M.lazy)
            -- }}}
            -- {{{ Post-plugin config
            M.post = ${encode (foldedList config.post)}
            -- }}}

            return M
          '';
        in
        { inherit dependencies; lua = luaConfig; };
      # }}}
    };
in
mkLib
