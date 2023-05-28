{
  authorizedKeys = { outputs, lib }:
    let
      # Record containing all the hosts
      hosts = outputs.nixosConfigurations;

      # Function from hostname to relative path to public ssh key
      idKey = host: ../../${host}/id_ed25519.pub;
    in
    lib.pipe hosts [
      # attrsetof host -> attrsetof path
      (builtins.mapAttrs
        (name: _: idKey name)) # string -> host -> path

      # attrsetof path -> path[]
      builtins.attrValues

      # path[] -> path[]
      (builtins.filter builtins.pathExists)
    ];
}
