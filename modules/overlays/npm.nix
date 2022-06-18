self: super:

let
  node = self.nodejs-18_x;
  customPackages = (import ./npm) { nodejs = node; pkgs = self; };
in
with self;  {
  nodejs = node;

  # Faster prettier for editors
  prettierd = customPackages."@fsouza/prettierd";

  # I need this for the css lang server thingy
  vscode-langservers-extracted = customPackages."vscode-langservers-extracted";
}
