# This file defines overlays
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });

    # {{{ Discordchatexporter
    discordchatexporter-cli = prev.discordchatexporter-cli.overrideAttrs (_: rec {
      version = "unstable-2023-06-21";
      src = prev.fetchFromGitHub {
        owner = "tyrrrz";
        repo = "discordchatexporter";
        rev = "bd4cfcdaf6abe0bd8863d5a4b3f2df2da838aea4";
        sha256 = "05j6y033852nm0fxhyv4mr4hnqc87nnkk85bw6sgf9gryjpxdcrq";
      };
    });
    # }}}
    # {{{ Discord
    # discord =
    #   let
    #     enableWayland = drv: bin: drv.overrideAttrs (
    #       old: {
    #         nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
    #         postFixup = (old.postFixup or "") + ''
    #           wrapProgram $out/bin/${bin} \
    #             --add-flags "--enable-features=UseOzonePlatform" \
    #             --add-flags "--ozone-platform=wayland"
    #         '';
    #       }
    #     );
    #   in
    #   enableWayland prev.discord "discord";
    # }}}
  };

  # Wayland version of plover
  plover = import ./plover.nix;
}
