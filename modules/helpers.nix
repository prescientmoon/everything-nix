{ lib, ... }: {
  mergeLines = (lines: lib.foldr
    (a: b: ''
      ${a}
      ${b}
    '') ""
    lines);
}
