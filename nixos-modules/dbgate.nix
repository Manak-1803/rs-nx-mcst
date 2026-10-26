{ inputs, ... }: {
  flake.modules.nixos.dbgate =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.dbgate;
    in
    {
      options.rsnxmcst.dbgate = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        systemd.services.podman-dbgate = {
          after = [ "init-podman-containers-network.service" ];
          requires = [ "init-podman-containers-network.service" ];
        };

        virtualisation.oci-containers.containers.dbgate = {
          image = "docker.io/dbgate/dbgate:latest";
          ports = [ ];

          volumes = [
            "/var/lib/containers/dbgate:/root/.dbgate"
          ];

          environment = {
            CONNECTIONS = "postgres";
            LABEL_postgres = "PostgreSQL Container";
            SERVER_postgres = "10.18.30.62";
            PORT_postgres = "5432";
            USER_postgres = "postgres";
            ENGINE_postgres = "postgres@dbgate-plugin-postgres";
          };

          extraOptions = [
            "--network=systemd-containers"
            "--ip=10.18.63.193"
          ];
        };
      };
    };
}
