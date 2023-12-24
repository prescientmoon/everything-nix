{ lib, korora, ... }:
let
  k = korora;

  # {{{ Lua encoders
  # {{{ Helpers 
  helpers = rec {
    xor = a: b: (a || b) && (!a || !b);
    implies = a: b: !a || b;
    hasProp = obj: p: (obj.${p} or null) != null;
    propXor = a: b: obj: xor (hasProp obj a) (hasProp obj b);
    propOnlyOne = props: obj:
      1 == lib.count (prop: obj ? prop);
    propImplies = a: b: obj: implies (hasProp obj a) (hasProp obj b);
    mkVerify = checks: obj:
      let
        results = lib.lists.map checks obj;
        errors = lib.lists.filter (v: v != null) results;
      in
      if errors == [ ]
      then null
      else
        let prettyErrors =
          lib.lists.map (s: "\n- ${s}") errors;
        in
        "Multiple errors occured: ${prettyErrors}";

    intersection = l: r:
      k.typedef'
        "${l.name} ∧ ${r.name}"
        (helpers.mkVerify [ l r ]);

    dependentAttrsOf =
      name: mkType:
      let
        typeError = name: v: "Expected type '${name}' but value '${toPretty v}' is of type '${typeOf v}'";
        addErrorContext = context: error: if error == null then null else "${context}: ${error}";

        withErrorContext = addErrorContext "in ${name} value";
      in
      k.typedef' name
        (v:
        if ! lib.isAttrs v then
          typeError name v
        else
          withErrorContext
            (mkVerify
              (lib.mapAttrsToList (k: _: mkType k) v)
              v));

    mkRawLuaObject = chunks:
      ''
        {
          ${lib.concatStringsSep "," (lib.filter (s: s != "") chunks)}
        }
      '';

    mkAttrName = s:
      let
        # These list *are* incomplete
        forbiddenChars = lib.stringToCharacters "<>[]{}()'\".,;";
        keywords = [ "if" "then" "else" "do" "for" "local" "" ];
      in
      if lib.any (c: lib.hasInfix c s) forbiddenChars || lib.elem s keywords then
        "[${m.string s}]"
      else s;

  };
  # }}}

  # We provide a custom set of helpers for generating lua code for nix.enable
  #
  # An encoder is a function from some nix value to a string containing lua code. 
  # This object provides combinators for writing such encoders.
  m = {
    # {{{ General helpers 
    typed = type: toLua: type // {
      unsafeToLua = toLua;
      toLua = v: toLua (type.check v);
      override = a: m.typed (type.override a) toLua;
    };
    withDefault = type: default: type // {
      default.value = default;
    };
    typedWithDefault = type: toLua: default:
      m.withDefault (m.typed type toLua) default;
    unsafe = type: type // { toLua = type.unsafeToLua; };
    untyped = m.typed k.any;
    untype = type: m.untyped type.toLua;
    withName = name: type: type // { inherit name; }; # TODO: should we use override here?
    # `const` is mostly useful together with `bind`. See the lua encoder for 
    # lazy modules for example usage.
    const = code: m.untyped (_: code);
    # Conceptually, this is the monadic bind operation for encoders.
    # This implementation is isomoprhic to that of the reader monad in haskell.
    bind = name: higherOrder:
      m.typed
        (k.typedef' name (v: (higherOrder v).verify v))
        (given: (higherOrder given).toLua given);
    # This is probably the most useful combinnator defined in this entire object.
    # Most of the combinators in the other categories are based on this.
    conditional = predicate: caseTrue: caseFalse:
      let base = m.bind
        m.bind
        "${caseTrue.name} ∨ ${caseFalse.name}"
        (given: if predicate given then caseTrue else caseFalse);
      in
      if caseTrue ? default then
        m.withDefault base caseTrue.default
      else if caseFalse ? default then
        m.withDefault base caseFalse.default
      else
        base;
    try = caseTrue: caseFalse:
      let base = m.bind
        "${caseTrue.name} ∨ ${caseFalse.name}"
        (given: if caseTrue.verify given == null then m.unsafe caseTrue else caseFalse);
      in
      if caseTrue ? default then
        m.withDefault base caseTrue.default
      else if caseFalse ? default then
        m.withDefault base caseFalse.default
      else
        base;
    oneOf = lib.foldr m.try
      (m.bottom (v: "No variants matched for value ${builtins.toJSON v}"));
    # This is simply left-composition of functions
    cmap = f: t:
      m.typed
        (lib.typedef' t.name (v: t.verify (f v)))
        (given: t.toLua (f given));
    # This is simply right-composition of functions
    map = f: t: m.typed t (given: f (t.toLua given));
    filter = predicate: type: given:
      m.conditional predicate type (m.untype m.nil);
    # This is mostly useful for debugging
    trace = message: m.cmap (f: lib.traceSeq message (lib.traceVal f));
    bottom = mkMessage: m.typed (m.typedef "⊥" mkMessage) lib.id;
    # }}}
    # {{{ Base types
    string = m.typed k.string (given: ''"${lib.escape ["\"" "\\"] (toString given)}"'');
    bool = m.typed k.bool (bool: if bool then "true" else "false");
    integer = m.typed k.int toString;
    float = m.typed k.float toString;
    number = m.typed k.number toString;
    ignored = type: m.typed type (_: "nil");
    nil = m.typedWithDefault
      (k.typedef "null" (v: v == null))
      (_: "nil")
      null;
    stringOr = m.try m.string;
    boolOr = m.try m.bool;
    numberOr = m.try m.number;
    nullOr = m.try m.nil;
    anything = m.withName "⊤" (m.oneOf [
      m.markedLuaCode # Lua code expressions have priority over attrsets
      m.string
      m.number
      m.bool
      m.null
      (m.listOf m.anything)
      (m.attrsetOf m.anything)
    ]);
    # }}}
    # {{{ Lua code
    identity = m.typed k.string lib.id;
    markedLuaCode =
      m.typed
        (k.struct "marked lua code" {
          value = k.string;
          __luaEncoderTag = k.enum "lua encoder tag" [ "lua" ];
        })
        (obj: obj.value);
    # This is the most rudimentary (and currently only) way of handling paths.
    luaImport = tag:
      m.typed (k.typedef "path" lib.isPath)
        (path: "dofile(${m.string "${path}"}).${tag}");
    # Accepts both tagged and untagged strings of lua code.
    luaString = m.try m.markedLuaCode m.identity;
    # This simply combines the above combinators into one.
    luaCode = tag: m.try (m.luaImport tag) m.luaString;
    # }}}
    # {{{ Operators
    conjunction = left: right: given:
      m.typed (helpers.intersection left right) (
        let
          l = left.toLua given;
          r = right.toLua given;
        in
        if l == "nil" then r
        else if r == "nil" then l
        else "${l} and ${r}"
      );
    all = lib.foldr m.conjunction m.nil;
    # Similar to `all` but takes in a list and
    # treats every element as a condition.
    allIndices = name: type: 
      m.bind name 
        (g: lib.pipe g [
          (lib.lists.imap0
            (i: _:
              m.cmap 
                (builtins.elemAt i) 
                type))
          m.all
        ]);
    # }}}
    # {{{ Lists
    listOf = type: list:
      m.typedWithDefault
        (k.listOf type)
        (helpers.mkRawLuaObject (lib.lists.map type.toLua list))
        [ ];
    listOfOr = type: m.try (m.listOf type);
    # Returns nil when given empty lists
    tryNonemptyList = type:
      m.typedWithDefault
        (k.listOf type)
        (m.filter
          (l: l != [ ])
          (m.listOf type))
        [ ];
    oneOrMany = type: m.listOfOr type type;
    # Can encode:
    # - zero values as nil
    # - one value as itself
    # - multiple values as a list
    zeroOrMany = type: m.nullOr (m.oneOrMany type);
    # Coerces non list values to lists of one element.
    oneOrManyAsList = type: m.listOfOr type (m.map (e: [ e ]) type);
    # Coerces lists of one element to said element.
    listAsOneOrMany = type:
      m.cmap
        (l: if lib.length l == 1 then lib.head l else l)
        (m.oneOrMany type);
    # }}}
    # {{{ Attrsets
    attrsetOf = type:
      m.typed (k.attrsOf type)
        (object:
          helpers.mkRawLuaObject (lib.mapAttrsToList
            (name: value:
              let result = type.toLua value;
              in
              lib.optionalString (result != "nil")
                "${helpers.mkAttrName name} = ${result}"
            )
            object
          )
        );
    # This is the most general combinator provided in this section.
    #
    # We accept:
    # - order of props that should be interpreted as list elements
    # - spec of props that should be interpreted as list elements
    # - record of props that should be interpreted as attribute props
    attrset = name: listOrder: spec: attrset:
      m.cmap
        (given: lib.mapAttrs
          (key: type:
            if given ? ${key} then
              given.${key}
            else
              type.default or null)
          spec)
        (m.typed (k.struct name spec) (
          let
            listChunks = lib.lists.map
              (attr:
                let result = spec.${attr}.toLua (attrset.${attr} or null);
                in
                lib.optionalString (result != "nil") result
              )
              listOrder;
            objectChunks = lib.mapAttrsToList
              (attr: type:
                let result = type.toLua (attrset.${attr} or null);
                in
                lib.optionalString (!(lib.elem attr listOrder) && result != "nil")
                  "${helpers.mkAttrName attr} = ${result}"
              )
              spec;
          in
          helpers.mkRawLuaObject (listChunks ++ objectChunks)
        ));
    withAttrsCheck = type: verify:
      type.override { inherit verify; };
    # }}}
  };
  # }}}
in
m // { inherit helpers; }
