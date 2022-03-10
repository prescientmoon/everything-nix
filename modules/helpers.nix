{ lib, ... }: {
  mergeLines = (lines: lib.lists.foldr
    (a: b: ''
      ${a}
      ${b}
    '') ""
    lines);
}
