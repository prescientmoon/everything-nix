{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ nixfmt niv cached-nix-shell ];
}
