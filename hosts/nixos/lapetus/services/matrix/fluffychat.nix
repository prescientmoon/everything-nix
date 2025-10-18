{ upkgs, ... }:
{
  satellite.nginx.at.fluffychat = {
    files = upkgs.fluffychat-web;
    subdomain = "fluffy";
  };
}
