{ pkgs, inputs, lib, ... }: {
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [{
        command = lib.getExe inputs.deploy-rs.packages.${pkgs.system}.default;
        options = [ "NOPASSWD" ];
      }];
      groups = [ "wheel" ];
    }];
  };
}
