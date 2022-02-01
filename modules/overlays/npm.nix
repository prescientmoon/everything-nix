self: super:
let customPackages = self.callPackage ./npm { };
in
with self; {
  # Faster prettier for editors
  prettierd = customPackages."@fsouza/prettierd";
}
