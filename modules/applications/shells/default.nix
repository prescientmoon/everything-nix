{ ... }: {
  imports = [ ./sessionVariables.nix ];
  home-manager.users.adrielus.programs = {
    zsh.enable = true;
    fish.enable = true;
  };
}
