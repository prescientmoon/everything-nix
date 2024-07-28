{ lib, korora, ... }:
let
  k = korora;

  # {{{ Helpers 
  helpers = rec {
    removeEmptyLines = str:
      lib.pipe str [
        (lib.splitString "\n")
        (lib.lists.filter
          (line: lib.any
            (c: c != " ")
            (lib.stringToCharacters line)))
        (lib.concatStringsSep "\n")
      ];

    hasType = type: value:
      let err = type.verify value; in
      lib.assertMsg (err == null) err;

    lua = value: assert hasType k.string value;
      { 
        inherit value; 
        __luaEncoderTag = "lua";
        __functor = _: arg: lua "(${value})(${encode arg})"; 
      };

    # {{{ Verification helpers 
    toPretty = lib.generators.toPretty { indent = "    "; };
    withError = cond: err: if cond then null else err;
    hasProp = obj: p: obj ? ${p};
    propExists = p: obj:
      helpers.withError
        (helpers.hasProp obj p)
        "Expected property ${p}";
    propXor = a: b: obj:
      helpers.withError
        ((hasProp obj a) != (hasProp obj b))
        "Expected only one of the properties ${a} and ${b} in object ${toPretty obj}";
    propOnlyOne = props: obj:
      helpers.withError
        (1 == lib.count (hasProp obj) props)
        "Expected exactly one property from the list ${toPretty props} in object ${toPretty obj}";
    propImplies = a: b: obj:
      helpers.withError
        ((hasProp obj a) -> (hasProp obj b))
        "Property ${a} should imply property ${b} in object ${toPretty obj}";
    mkVerify = checks: obj:
      assert lib.all lib.isFunction checks;
      let
        results = lib.lists.map (c: c obj) checks;
        errors = lib.lists.filter (v: v != null) results;
      in
      assert lib.all lib.isString errors;
      if errors == [ ]
      then null
      else
        let prettyErrors =
          lib.lists.map (s: "\n- ${s}") errors;
        in
        "Multiple errors occured: ${lib.concatStrings prettyErrors}";
    # }}}
    # {{{ Custom types
    intersection = l: r:
      k.typedef'
        "${l.name} ∧ ${r.name}"
        (helpers.mkVerify [ l r ]);

    # dependentAttrsOf =
    #   name: mkType:
    #   let
    #     typeError = name: v: "Expected type '${name}' but value '${toPretty v}' is of type '${typeOf v}'";
    #     addErrorContext = context: error: if error == null then null else "${context}: ${error}";
    #
    #     withErrorContext = addErrorContext "in ${name} value";
    #   in
    #   k.typedef' name
    #     (v:
    #     if ! lib.isAttrs v then
    #       typeError name v
    #     else
    #       withErrorContext
    #         (mkVerify
    #           (lib.mapAttrsToList (k: _: mkType k) v)
    #           v));
    # }}}
    # {{{ Encoding helpers
    mkRawLuaObject = chunks:
      ''
        {
          ${lib.concatStringsSep "," (lib.filter (s: s != "") chunks)}
        }
      '';

    encodeString = given:
      if lib.hasInfix "\n" given then
        ''[[${(toString given)}]]'' # This is not perfect but oh well
      else
        ''"${lib.escape ["\"" "\\"] (toString given)}"'';

    mkAttrName = s:
      let
        # A "good enough" approach to figuring out the correct encoding for attribute names
        allowedStartingChars = lib.stringToCharacters "abcdefghijklmnopqrstuvwxyz_";
        allowedChars = allowedStartingChars ++ lib.stringToCharacters "0123456789";
        keywords = [ "if" "then" "else" "do" "for" "local" "" ];
      in
      if builtins.match "([a-zA-Z_][a-zA-Z_0-9]*)" s != [ s ] || lib.elem s keywords then
        "[${helpers.encodeString s}]"
      else s;
    # }}}
  };
  # }}}
  # {{{ Encoding
  isLuaLiteral = given: lib.isAttrs given && given.__luaEncoderTag or null == "lua";
  encodeWithDepth = depth: given:
    let recurse = encodeWithDepth depth; in
    if lib.isString given || lib.isDerivation given || lib.isPath given then
      helpers.encodeString given
    else if lib.isInt given || lib.isFloat given then
      toString given
    else if lib.isBool given then
      if given then "true" else "false"
    else if given == null then
      "nil"
    else if lib.isList given then
      helpers.mkRawLuaObject (lib.lists.map recurse given)
    else if lib.isAttrs given && given.__luaEncoderTag or null == "foldedList" then
      let
        makeFold = name: value: ''
          -- {{{ ${name}
          ${recurse value},
          -- }}}'';
        folds = lib.mapAttrsToList makeFold given.value;
      in
      ''
        {
          ${lib.concatStringsSep "\n" folds}
        }''
    else if isLuaLiteral given then
      given.value
    else if lib.isAttrs given then
      helpers.mkRawLuaObject
        (lib.mapAttrsToList
          (name: value:
            let result = recurse value;
            in
            lib.optionalString (result != "nil")
              "${helpers.mkAttrName name} = ${result}"
          )
          given)
    else if lib.isFunction given then
      let
        argNames = [ "context" "inner_context" "local_context" ];
        secretArg =
          if depth >= builtins.length argNames
          then "arg_${depth}"
          else builtins.elemAt argNames depth;
        body = given secretArg;
        encoded = encodeWithDepth (depth + 1) body;
        encodedBody =
          if isLuaLiteral body
          then encoded
          else "return ${encoded}";
      in
      if lib.hasInfix secretArg encoded
      then ''
        function(${secretArg})
          ${encodedBody}
        end''
      else ''
        function()
          ${encodedBody}
        end''
    else builtins.throw "Cannot encode value ${helpers.toPretty given}";
  # }}}
  encode = encodeWithDepth 0;
in
{ inherit encode helpers; }
