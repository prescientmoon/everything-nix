{
  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ /etc/nixos/hardware-configuration.nix ./configuration.nix ];
    };
  };
}
