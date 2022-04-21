{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    hplip
  ];
}
