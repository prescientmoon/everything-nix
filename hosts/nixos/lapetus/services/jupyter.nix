{ config, pkgs, ... }: {
  services.nginx.virtualHosts."jupyter.moonythm.dev" =
    config.satellite.proxy
      config.services.jupyterhub.port
      { proxyWebsockets = true; };

  services.jupyterhub = {
    enable = true;
    port = 8420;

    extraConfig = ''
      c.Authenticator.allowed_users = {'prescientmoon'}
      c.Authenticator.admin_users = {'prescientmoon'}

      c.SystemdSpawner.mem_limit = '2G'
      c.SystemdSpawner.cpu_limit = 2.0
    '';

    # {{{ Python 3 kernel
    kernels.python3 =
      let env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
        ipykernel
        pandas
        scikit-learn
      ]));
      in
      {
        displayName = "Python 3 for machine learning";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
        logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
        logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
      };
    # }}}
  };

  environment.persistence."/persist/state".directories = [
    "/var/lib/${config.services.jupyterhub.stateDirectory}"
  ];
}
