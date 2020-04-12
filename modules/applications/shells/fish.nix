{ pkgs, ... }:
let shellAliases = import ./aliases.nix;
in {
  home-manager.users.adrielus.programs.fish = {
    inherit shellAliases;

    enable = true;
    # plugins = [{
    #   name = "agnoster";
    #   src = pkgs.agnoster;
    # }];
  };
}
