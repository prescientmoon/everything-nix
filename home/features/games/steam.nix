# Although steam is installed globally by nixos,
# there's some extra settings we make for a specific user!
{
  home.persistence."/persist/home/adrielus" = {
    files = [
      ".steam/registry.vdf" # It seems like auto-login does not work without this
    ];

    directories = [
      # TODO: perhaps this should leave in it's own file?
      ".factorio"

      # A couple of games don't play well with bindfs
      {
        directory = ".local/share/Steam";
        method = "symlink";
      }
    ];
  };
}
