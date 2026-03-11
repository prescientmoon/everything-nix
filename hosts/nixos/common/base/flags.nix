# This file allows assigning various flags to machines. There is a question to
# be had about whether having separate flags for interactible/graphical/gaming
# machines is a good idea when I could instead simply have a single option typed
# by an enum. These flags are nice at the usage-site, so even with such an
# option I'd keep them around (as read-only). For now the number of flags is
# small enough that I do not mind manually typing them out. Moreover, there's
# assertions in place to ensure that the given flags are coherent.
{ config, lib, ... }:
let
  cfg = config.satellite.machine;
in
{
  options.satellite.machine = {
    graphical = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "
        Whether modules requiring a graphical user interface should be enabled.
        Note that features like audio and bluetooth support get bundled with
        this throughout most of the config, as I don't use them on any 
        non-graphical machines. Still, I should one day come up with a better
        name for this.
      ";
    };

    interactible = lib.mkOption {
      default = config.satellite.machine.graphical;
      type = lib.types.bool;
      description = ''
        Whether this machine is physically interactible with. Enables things 
        like specific keyboard layouts.

        This differs from the "graphical" flag, since machines like my home 
        server(s) need to some times be manually typed on, even though they 
        do not offer any visuals besides the stock tty.
      '';
    };

    gaming = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "
        Whether this machine will be used to play games.
      ";
    };
  };

  config.assertions = [
    {
      assertion = cfg.graphical -> cfg.interactible;
      message = "Graphical machines must be marked as interactible.";
    }
    {
      assertion = cfg.gaming -> cfg.graphical;
      message = "Gaming machines must be marked as graphical.";
    }
  ];
}
