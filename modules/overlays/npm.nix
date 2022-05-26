self: super:
let customPackages = (import ./npm) { nodejs = self.nodejs-17_x; pkgs = self; };
in
with self; {
  # Faster prettier for editors
  prettierd = customPackages."@fsouza/prettierd";

  # I need this for the css lang server thingy
  vscode-langservers-extracted = customPackages."vscode-langservers-extracted";
}
