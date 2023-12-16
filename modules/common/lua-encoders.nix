{ config, lib, pkgs, ... }:
let
  # {{{ Lua encoders
  # We provide a custom set of helpers for generating lua code for nix.enable
  #
  # An encoder is a function from some nix value to a string containing lua code. 
  # This object provides combinators for writing such encoders.
  luaEncoders = {
    # {{{ "Raw" helpers 
    mkRawLuaObject = chunks:
      ''
        {
          ${lib.concatStringsSep "," (lib.filter (s: s != "") chunks)}
        }
      '';
    # }}}
    # {{{ General helpers 
    identity = given: given;
    # `const` is mostly useful together with `bind`. See the lua encoder for 
    # lazy modules for example usage.
    const = code: _: code;
    # Conceptually, this is the monadic bind operation for encoders.
    # This implementation is isomoprhic to that of the reader monad in haskell.
    bind = encoder: given: encoder given given;
    # This is probably the most useful combinnator defined in this entire object.
    # Most of the combinators in the other categories are based on this.
    conditional = predicate: caseTrue: caseFalse:
      luaEncoders.bind (given: if predicate given then caseTrue else caseFalse);
    # This is simply left-composition of functions
    map = f: encoder: given: encoder (f given);
    # This is simply right-composition of functions
    postmap = f: encoder: given: f (encoder given);
    filter = f: encoder: luaEncoders.conditional f encoder luaEncoders.nil;
    # This is mostly useful for debugging
    trace = message: luaEncoders.map (f: lib.traceSeq message (lib.traceVal f));
    fail = mkMessage: v: builtins.throw (mkMessage v);
    # }}}
    # {{{ Base types
    string = given: ''"${lib.escape ["\"" "\\"] (toString given)}"'';
    bool = bool: if bool then "true" else "false";
    number = toString;
    nil = _: "nil";
    stringOr = luaEncoders.conditional lib.isString luaEncoders.string;
    boolOr = luaEncoders.conditional lib.isBool luaEncoders.bool;
    numberOr = luaEncoders.conditional (e: lib.isFloat e || lib.isInt e) luaEncoders.number;
    nullOr = luaEncoders.conditional (e: e == null) luaEncoders.nil;
    # We pipe a combinator which always fail through a bunch of
    # `(thing)or : encoder -> encoder` functions, building up a combinator which
    # can handle more and more kinds of values, until we eventually build up
    # something that should be able to handle everything we throw at it.
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
    # Tagged lua code can be combined with other combinators without worrying
    # about conflicts regarding how strings are interpreted.
    luaCodeOr =
      luaEncoders.conditional (e: lib.isAttrs e && (e.__luaEncoderTag or null) == "lua")
        (obj: obj.value);
    # This is the most rudimentary (and currently only) way of handling paths.
    luaImportOr = tag:
      luaEncoders.conditional lib.isPath
        (path: "dofile(${luaEncoders.string path}).${tag}");
    # Accepts both tagged and untagged strings of lua code.
    luaString = luaEncoders.luaCodeOr luaEncoders.identity;
    # This simply combines the above combinators into one.
    luaCode = tag: luaEncoders.luaImportOr tag luaEncoders.luaString;
    # }}}
    # {{{ Operators
    conjunction = left: right: given:
      let
        l = left given;
        r = right given;
      in
      if l == "nil" then r
      else if r == "nil" then l
      else "${l} and ${r}";
    # }}}
    # {{{ Lists
    listOf = encoder: list:
      luaEncoders.mkRawLuaObject (lib.lists.map encoder list);
    listOfOr = encoder:
      luaEncoders.conditional
        lib.isList
        (luaEncoders.listOf encoder);
    # Returns nil when given empty lists
    tryNonemptyList = encoder:
      luaEncoders.filter
        (l: l != [ ])
        (luaEncoders.listOf encoder);
    oneOrMany = encoder: luaEncoders.listOfOr encoder encoder;
    # Can encode:
    # - zero values as nil
    # - one value as itself
    # - multiple values as a list
    zeroOrMany = encoder: luaEncoders.nullOr (luaEncoders.oneOrMany encoder);
    # Coerces non list values to lists of one element.
    oneOrManyAsList = encoder: luaEncoders.map
      (given: if lib.isList given then given else [ given ])
      (luaEncoders.listOf encoder);
    # Coerces lists of one element to said element.
    listAsOneOrMany = encoder:
      luaEncoders.map
        (l: if lib.length l == 1 then lib.head l else l)
        (luaEncoders.oneOrMany encoder);
    # }}}
    # {{{ Attrsets
    attrName = s:
      let forbiddenChars = lib.stringToCharacters "<>'\".,;"; # This list *is* incomplete
      in
      if lib.any (c: lib.hasInfix c s) forbiddenChars then
        "[${luaEncoders.string s}]"
      else s;

    attrsetOf = encoder: object:
      luaEncoders.mkRawLuaObject (lib.mapAttrsToList
        (name: value:
          let result = encoder value;
          in
          lib.optionalString (result != "nil")
            "${luaEncoders.attrName name} = ${result}"
        )
        object
      );
    attrsetOfOr = of: luaEncoders.conditional lib.isAttrs (luaEncoders.attrsetOf of);
    # This is the most general combinator provided in this section.
    #
    # We accept:
    # - a `noNils` flag which will automatically remove any nil properties
    # - order of props that should be interpreted as list elements
    # - spec of props that should be interpreted as list elements
    # - record of props that should be interpreted as attribute props
    attrset = noNils: listOrder: spec: attrset:
      let
        shouldKeep = given:
          if noNils then
            given != "nil"
          else
            true;

        listChunks = lib.lists.map
          (attr:
            let result = spec.${attr} (attrset.${attr} or null);
            in
            lib.optionalString (shouldKeep result) result
          )
          listOrder;
        objectChunks = lib.mapAttrsToList
          (attr: encoder:
            let result = encoder (attrset.${attr} or null);
            in
            lib.optionalString (!(lib.elem attr listOrder) && shouldKeep result)
              "${luaEncoders.attrName attr} = ${result}"
          )
          spec;
      in
      luaEncoders.mkRawLuaObject (listChunks ++ objectChunks);
    # }}}
  };
  # }}}
in
{
  options.satellite.lib.lua = {
    encoders = lib.mkOption {
      # I am too lazy to make this typecheck
      type = lib.types.anything;
      description = "Combinators used to encode nix values as lua values";
    };

    writeFile = lib.mkOption {
      type = with lib.types; functionTo (functionTo (functionTo path));
      description = "Format and write a lua file to disk";
    };
  };

  options.satellite.lua.styluaConfig = lib.mkOption {
    type = lib.types.path;
    description = "Config to use for formatting lua modules";
  };

  config.satellite.lib.lua = {
    encoders = luaEncoders;

    writeFile = path: name: text:
      let
        destination = "${path}/${name}.lua";
        unformatted = pkgs.writeText "raw-lua-${name}" ''
          -- ❄️ This file was generated using nix ^~^
          ${text}
        '';
      in
      pkgs.runCommand "formatted-lua-${name}" { } ''
        mkdir -p $out/${path}
        cp --no-preserve=mode ${unformatted} $out/${destination}
        ${lib.getExe pkgs.stylua} --config-path ${config.satellite.lua.styluaConfig} $out/${destination}
      '';
  };
}
