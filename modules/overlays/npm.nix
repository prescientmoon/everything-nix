self: super:
let customPackages = pkgs.callPackage ./npm { };
in with self; {
  # Faster prettier for editors
  nodePackages.prettierd = customPackages."@fsouza/prettierd";
}
