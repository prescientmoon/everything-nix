{
  pkgs,
  octodnsConfig,
  nixosConfigurations ? { },
  extraModules ? [ ],
}:
rec {
  #  {{{ Build zone files
  octodns-zones =
    let
      nixosConfigModules = pkgs.lib.mapAttrsToList (_: current: {
        satellite.dns = current.config.satellite.dns;
      }) nixosConfigurations;

      evaluated = pkgs.lib.evalModules {
        specialArgs = {
          inherit pkgs;
        };

        modules = [ ./nixos-module.nix ] ++ nixosConfigModules ++ extraModules;
      };
    in
    import ./gen-zone-file.nix {
      inherit pkgs;
      inherit (evaluated) config;
    };
  #  }}}
  #  {{{ Make the CLI use the newly built zone files
  octodns-sync = pkgs.symlinkJoin {
    name = "octodns-sync";
    paths = [
      (pkgs.octodns.withProviders (ps: [
        pkgs.octodns-providers.cloudflare
      ]))
    ];

    buildInputs = [
      pkgs.makeWrapper
      pkgs.yq
    ];

    postBuild = ''
      cat ${octodnsConfig} | yq '.providers.zones.directory="${octodns-zones}"' > $out/config.yaml
      wrapProgram $out/bin/octodns-sync \
        --run 'export CLOUDFLARE_TOKEN=$( \
            sops \
              --decrypt \
              --extract "[\"cloudflare_dns_api_token\"]" \
              ./hosts/nixos/common/secrets.yaml \
          )' \
        --add-flags "--config-file $out/config.yaml"
    '';
  };
  #  }}}
}
