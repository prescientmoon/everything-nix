self: super:
let customPackages = self.callPackage ./npm { };
in
with self; {
  # Faster prettier for editors
  prettierd = customPackages."@fsouza/prettierd";

  # I need this for the css lang server thingy
  vscode-langservers-extracted = customPackages."vscode-langservers-extracted";
}
