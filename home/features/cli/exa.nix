{ pkgs, ... }: {
  home.packages = [ pkgs.exa ];

  # TODO: generalize alias creation to all shells
  programs.fish.shellAliases =
    let exa = "${pkgs.exa}/bin/exa";
    in
    rec {
      ls = "${exa} --icons --long";
      la = "${ls} --all";
      lt = "${ls} --tree"; # Similar to tree, but also has --long!

      # I am used to using pkgs.tree, so this is nice to have!
      tree = "${exa} --icons --tree";
    };
}
