{ upkgs, ... }:
{
  imports = [
    ./continuwuity.nix
    ./element.nix
    ./fluffychat.nix
  ];

  satellite.nginx.at = {
    element = {
      files = upkgs.element-web;
    };

    fluffychat = {
      files = upkgs.fluffychat-web;
      subdomain = "fluffy";
    };
  };
}
