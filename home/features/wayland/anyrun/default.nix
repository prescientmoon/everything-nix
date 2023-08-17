{ inputs, pkgs, ... }: {
  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        dictionary
        rink
        stdin
        symbols
        websearch
      ];

      width.fraction = 0.5;
      height.fraction = 0.6;
    };
  };
}
