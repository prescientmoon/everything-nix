{ pkgs, ... }:
pkgs.mkShell {
  packages = with pkgs; [
    typescript
    nodejs
  ];
}
