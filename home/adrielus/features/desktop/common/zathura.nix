{ config, pkgs, ... }:
let base16-zathura = pkgs.fetchFromGitHub {
  owner = "doenerkebap";
  repo = "base16-zathura";
  sha256 = "1zcrzll13d4lmyzibwdqkkdssyhr3c9s4yxhqigg3azsizk8adb4";
  rev = "2caef8fff6a5412e05950c6105c5020a6f16ead2";
};
in
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      # Generated theme
      ${builtins.readFile (config.scheme base16-zathura)}

      # Open document in fit-width mode by default
      set adjust-open "best-fit"

      # Inject font
      set font "${config.fontProfiles.regular.family}"
    '';
  };
}
