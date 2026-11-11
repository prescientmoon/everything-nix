{ pkgs, ... }:
{
  imports = [ ./fish.nix ];

  environment.systemPackages = with pkgs; [
    dua # du + ncdu replacement
    dust # Similar to du, but with prettier output
    dysk # Similar to df, but with prettier output
    nerdfetch # Display system information
  ];
}
