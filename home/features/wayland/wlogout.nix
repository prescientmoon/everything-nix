{ config
, pkgs
, ...
}:
let bgImageSection = name: ''
  #${name} {
    background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/${name}.png"));
  }
'';
in
{
  xdg.configFile."wlogout/style.css".text = ''
    * {
      background-image: none;
      font-family: ${config.stylix.fonts.sansSerif.name};
    }

    window {
      background-color: rgba(${config.satellite.theming.colors.rgba "base00"});
    }

    button {
      color: rgb(${config.satellite.theming.colors.rgb "base05"});
      background: rgba(${config.satellite.theming.colors.rgb "base01"}, 0.2);
      border-radius: 8px;
      box-shadow: .5px .5px 1.5px 1.5px rgba(0, 0, 0, .5);
      margin: 1rem;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
    }

    button:focus, button:active, button:hover {
      background-color: rgba(${config.satellite.theming.colors.rgb "base02"}, 0.5);
      outline-style: none;
    }

    ${bgImageSection "lock"}
    ${bgImageSection "logout"}
    ${bgImageSection "suspend"}
    ${bgImageSection "hibernate"}
    ${bgImageSection "shutdown"}
    ${bgImageSection "reboot"}
  '';
}
