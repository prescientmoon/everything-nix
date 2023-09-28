{ upkgs, lib, ... }: {
  # REASON: not yet in nixpkgs-stable
  home.packages = [ upkgs.eza ];

  # TODO: generalize alias creation to all shells
  programs.fish.shellAliases =
    let eza = lib.getExe upkgs.eza;
    in
    rec {
      ls = "${eza} --icons --long";
      la = "${ls} --all";
      lt = "${ls} --tree"; # Similar to tree, but also has --long!

      # I am used to using pkgs.tree, so this is nice to have!
      tree = "${eza} --icons --tree";
    };
}
