# Auto-generated using compose2nix v0.3.1-pre.
{ pkgs, lib, ... }:

{
  # Containers
  virtualisation.oci-containers.containers."5d-diplomacy-backend" = {
    image = "localhost/compose2nix-5d-diplomacy-backend";
    environment = {
      "ConnectionStrings__Database" = "Server=mssql;Database=diplomacy;User=SA;Password=Passw0rd@;Encrypt=True;TrustServerCertificate=True";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=backend"
      "--network=5d-diplomacy_default"
    ];
  };
  systemd.services."docker-5d-diplomacy-backend" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-build-5d-diplomacy-backend.service"
      "docker-network-5d-diplomacy_default.service"
    ];
    requires = [
      "docker-build-5d-diplomacy-backend.service"
      "docker-network-5d-diplomacy_default.service"
    ];
    partOf = [ "docker-compose-5d-diplomacy-root.target" ];
    wantedBy = [ "docker-compose-5d-diplomacy-root.target" ];
  };
  virtualisation.oci-containers.containers."5d-diplomacy-frontend" = {
    image = "localhost/compose2nix-5d-diplomacy-frontend";
    ports = [ "127.0.0.1:5173:8080/tcp" ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=frontend"
      "--network=5d-diplomacy_default"
    ];
  };
  systemd.services."docker-5d-diplomacy-frontend" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-build-5d-diplomacy-frontend.service"
      "docker-network-5d-diplomacy_default.service"
    ];
    requires = [
      "docker-build-5d-diplomacy-frontend.service"
      "docker-network-5d-diplomacy_default.service"
    ];
    partOf = [ "docker-compose-5d-diplomacy-root.target" ];
    wantedBy = [ "docker-compose-5d-diplomacy-root.target" ];
  };
  virtualisation.oci-containers.containers."5d-diplomacy-mssql" = {
    image = "mcr.microsoft.com/mssql/server:2022-latest";
    environment = {
      "ACCEPT_EULA" = "y";
      "MSSQL_SA_PASSWORD" = "Passw0rd@";
    };
    volumes = [
      "/home/moon/projects/5d-diplomacy-with-multiverse-time-travel/mssql-data/data:/var/opt/mssql/data:rw"
      "/home/moon/projects/5d-diplomacy-with-multiverse-time-travel/mssql-data/log:/var/opt/mssql/log:rw"
      "/home/moon/projects/5d-diplomacy-with-multiverse-time-travel/mssql-data/secrets:/var/opt/mssql/secrets:rw"
    ];
    user = "root";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mssql"
      "--network=5d-diplomacy_default"
    ];
  };
  systemd.services."docker-5d-diplomacy-mssql" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "no";
    };
    after = [ "docker-network-5d-diplomacy_default.service" ];
    requires = [ "docker-network-5d-diplomacy_default.service" ];
    partOf = [ "docker-compose-5d-diplomacy-root.target" ];
    wantedBy = [ "docker-compose-5d-diplomacy-root.target" ];
  };

  # Networks
  systemd.services."docker-network-5d-diplomacy_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f 5d-diplomacy_default";
    };
    script = ''
      docker network inspect 5d-diplomacy_default || docker network create 5d-diplomacy_default
    '';
    partOf = [ "docker-compose-5d-diplomacy-root.target" ];
    wantedBy = [ "docker-compose-5d-diplomacy-root.target" ];
  };

  # Builds
  systemd.services."docker-build-5d-diplomacy-backend" = {
    path = [
      pkgs.docker
      pkgs.git
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutSec = 300;
    };
    script = ''
      cd /home/moon/projects/5d-diplomacy-with-multiverse-time-travel/server
      docker build -t compose2nix-5d-diplomacy-backend .
    '';
    partOf = [ "docker-compose-5d-diplomacy-root.target" ];
    wantedBy = [ "docker-compose-5d-diplomacy-root.target" ];
  };
  systemd.services."docker-build-5d-diplomacy-frontend" = {
    path = [
      pkgs.docker
      pkgs.git
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      TimeoutSec = 300;
    };
    script = ''
      cd /home/moon/projects/5d-diplomacy-with-multiverse-time-travel/client
      docker build -t compose2nix-5d-diplomacy-frontend .
    '';
    partOf = [ "docker-compose-5d-diplomacy-root.target" ];
    wantedBy = [ "docker-compose-5d-diplomacy-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-5d-diplomacy-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
