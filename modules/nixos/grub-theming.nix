{ pkgs, config, lib, ... }:

with config.scheme.withHashtag;

let
  fontProfiles = {
    enable = true;

    monospace = {
      family = "FiraCode Nerd Font";
      package = pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; };
    };

    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };

  # See [this file](https://github.com/danth/stylix/blob/master/stylix/pixel.nix)
  # Generate a PNG image containing a named color
  pixel = color:
    pkgs.runCommand "${color}-pixel.png"
      {
        color = config.scheme.withHashtag.${color};
      } "${pkgs.imagemagick}/bin/convert xc:$color png32:$out";

  # Grub requires fonts to be converted to "PFF2 format"
  # This function takes a font { name, package } and produces a .pf2 file
  mkGrubFont = font:
    pkgs.runCommand "${font.package.name}.pf2"
      {
        FONTCONFIG_FILE =
          pkgs.makeFontsConf { fontDirectories = [ font.package ]; };
      } ''
      # Use fontconfig to select the correct .ttf or .otf file based on name
      font=$(
        ${pkgs.fontconfig}/bin/fc-match -v "${font.family}" \
        | grep "file:" | cut -d '"' -f 2
      )

      # Convert to .pf2
      ${pkgs.grub2}/bin/grub-mkfont $font --output $out --size 17
    '';

in
{
  options.boot.loader.grub.base16 = {
    enable = lib.mkOption {
      description = "Whether to generate base16 grub theme";
      type = lib.types.bool;
      default = false;
    };

    useImage = lib.mkOption {
      description = "Whether to use your wallpaper image as the GRUB background.";
      type = lib.types.bool;
      default = false;
    };
  };

  config.boot.loader.grub = lib.mkIf config.boot.loader.grub.base16.enable {
    backgroundColor = base00;

    # Need to override the NixOS splash, this will match the background
    splashImage = pixel "base00";

    # This font will be used for the GRUB terminal
    font = toString (mkGrubFont fontProfiles.monospace);

    # TODO: Include OS icons
    theme =
      let font = fontProfiles.regular;
      in
      pkgs.runCommand "stylix-grub"
        {
          themeTxt = ''
            desktop-image: "background.png"
            desktop-image-scale-method: "crop"
            desktop-color: "${base00}"

            title-text: ""

            terminal-left: "10%"
            terminal-top: "20%"
            terminal-width: "80%"
            terminal-height: "60%"

            + progress_bar {
              left = 25%
              top = 80%+20  # 20 pixels below boot menu
              width = 50%
              height = 30

              id = "__timeout__"
              show_text = true
              font = "${font.family}"
              text = "@TIMEOUT_NOTIFICATION_MIDDLE@"

              border_color = "${base00}"
              bg_color = "${base00}"
              fg_color = "${base0B}"
              text_color = "${base05}"
            }

            + boot_menu {
              left = 25%
              top = 20%
              width = 50%
              height = 60%
              menu_pixmap_style = "background_*.png"

              item_height = 40
              item_icon_space = 8
              item_spacing = 0
              item_padding = 0
              item_font = "${font.family}"
              item_color = "${base05}"

              selected_item_color = "${base01}"
              selected_item_pixmap_style = "selection_*.png"
            }
          '';
          passAsFile = [ "themeTxt" ];
        } ''
        mkdir $out
        cp $themeTxtPath $out/theme.txt

        ${if config.boot.loader.grub.base16.useImage
        # Make sure the background image is .png by asking to convert it
        then
          # TODO: this doesn't work because I have no wallpaper module
          "${pkgs.imagemagick}/bin/convert ${config.stylix.image} png32:$out/background.png"
        else
          "cp ${pixel "base00"} $out/background.png"}

        cp ${pixel "base01"} $out/background_c.png
        cp ${pixel "base0B"} $out/selection_c.png

        cp ${mkGrubFont font} $out/sans_serif.pf2
      '';
  };
}
