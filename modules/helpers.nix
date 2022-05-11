{ lib, ... }: {
  mergeLines = lib.lists.foldr
    (a: b: ''
      ${a}
      ${b}
    '') "";

  unwords = lib.lists.foldr (a: b: ''${a} ${b}'') "";
}
