{ pkgs, paths, ... }:
let vieb = "/home/adrielus/.config/Vieb"; in
{
  home-manager.users.adrielus = {
    home.packages = [ pkgs.nixos-unstable.vieb ];
    systemd.user.tmpfiles.rules = [
      "L+ /home/adrielus/.viebrc - - - - ${paths.dotfiles}/vieb/.viebrc"
    ];
  };
}
