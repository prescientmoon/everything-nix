attrs@{ lib, ... }:
let
  e = import ./korora-lua.nix attrs;
  h = e.helpers;
  m = {
    lazyModule = e.withAttrsCheck
      (e.attrset "lazy module" [ "package" ] {
        package = e.nullOr e.string;
        dir = e.nullOr e.type;
        version = e.nullOr e.string;
        tag = e.nullOr e.string;
        name = e.nullOr e.string;
        main = e.nullOr e.string;
        lazy = e.nullOr e.bool;
        dependencies = e.tryNonemptyList (e.stringOr m.lazyModule);
        config = e.anything;
        cond = e.nullOr (e.bind (value: e.all [
          # TODO: we want a zip here
          (e.nullOr (e.luaCode "cond"))
        ]));
        init = e.nullOr (e.luaCode "init");
        event = e.zeroOrMany e.string;
        cmd = e.zeroOrMany e.string;
        ft = e.zeroOrMany e.string;
        keys = e.listOf e.anything;
        passthrough = e.anything;
        opts = e.anything;
      })
      (h.mkVerify [
        (h.propOnlyOne [ "dir" "package" ])
        (h.propImplies "tag" "package")
        (h.propImplies "version" "package")
      ]);
  };
in
m
