{ upkgs, ... }:
{
  imports = [ ./continuwuity.nix ];

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
