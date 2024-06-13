# I couldn't find a hosted version of this
{ pkgs, config, ... }: {
  satellite.nginx.at.diptime.files = pkgs.fetchFromGitHub {
    owner = "bhickey";
    repo = "diplomatic-timekeeper";
    rev = "d6ea7b9d9e94ee6d2db8e4e7cff5f8f1c3f04464";
    sha256 = "09s6awz5m6hzpc6jp96c118i372430c7b41acm5m62bllcvrj9vk";
  };
}
