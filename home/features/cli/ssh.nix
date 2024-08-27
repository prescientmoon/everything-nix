{ config, ... }:
{
  programs.ssh.enable = true;
  satellite.persistence.at.state.apps.ssh.directories = [ ".ssh" ];
}
