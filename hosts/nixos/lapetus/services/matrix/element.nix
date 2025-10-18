{ upkgs, ... }:
{
  satellite.nginx.at.element.files = upkgs.element-web;
}
