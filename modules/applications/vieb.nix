{ pkgs, paths, ... }:
let vieb = "/home/adrielus/.config/Vieb"; in
{
  home-manager.users.adrielus = {
    home.packages = [ pkgs.vieb ];
    systemd.user.tmpfiles.rules = [
      "L+ /home/adrielus/.viebrc - - - - ${paths.dotfiles}/vieb/.viebrc"
    ];
  };
}
