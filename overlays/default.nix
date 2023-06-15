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

    # {{{ Wezterm
    # REASON: https://github.com/wez/wezterm/issues/3529 doesn't seem to be fixed on stable
    wezterm = prev.wezterm.overrideAttrs (_: {
      version = "unstable-2023-06-12";
      src = prev.fetchFromGitHub {
        owner = "wez";
        repo = "wezterm";
        rev = "baf9d970816e015bee41ed5eb9186ef7f71c454c";
        hash = "sha256-0pqfpn12963hfwdhgdwx9fwjngv6j2i6w9d20hcp1saxfd7q5l7m";
        fetchSubmodules = true;
      };
    });
    # }}}
  };

  # Wayland version of plover
  plover = import ./plover.nix;
}
