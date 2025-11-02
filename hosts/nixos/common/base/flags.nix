{ config, lib, ... }:
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

    # TODO: add assert forcing this to imply graphical
    gaming = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "
        Whether this machine will be used to play games.
      ";
    };
  };
}
