{ pkgs, config, ... }:
let
  base16-wofi = config.lib.stylix.colors {
    templateRepo = pkgs.fetchFromSourcehut {
      owner = "~knezi";
      repo = "base16-wofi";
      rev = "2182a5ad36d372e625b3d8e1a20ba7447e77ed22";
      sha256 = "0hzn9lgh7rzahmzzdsgxnz4f8vvcpx5diwsnc7gb29gj9nbb1a8f";
    };
  };
in
{
  programs.wofi = {
    enable = true;
    settings = {
      allow_markup = true;
      allow_images = true;
    };
  };

  # xdg.configFile."wofi/style.css".source = base16-wofi;
}

