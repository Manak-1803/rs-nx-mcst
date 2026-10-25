{ inputs, ... }: {
  flake.modules.nixos.attic =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.attic-server;

      attic-config = {
        listen = "10.18.130.108:8000";

        database.url = "postgresql://atticd@10.18.30.62:5432/atticd";
        garbage-collection.interval = "7 days";
        compression.type = "zstd";

        storage = {
          type = "local";
          path = "/attic/storage";
        };

        chunking = {
          nar-size-threshold = 65536;
          min-size = 16384;
          avg-size = 65536;
          max-size = 262144;
        };
      };

      attic-config-file = (pkgs.formats.toml { }).generate "attic-server.toml" attic-config;
    in
    {
      options.rsnxmcst.attic-server = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        systemd.services.podman-attic-server = {
          after = [ "init-podman-containers-network.service" ];
          requires = [ "init-podman-containers-network.service" ];
        };

        sops.secrets."envs/attic" = { };
        rsnxmcst.postgresql.userDatabases = [ "atticd" ];

        virtualisation.oci-containers.containers.attic-server = {
          image = "ghcr.io/zhaofengli/attic:latest";
          ports = [ ];

          cmd = [
            "-f"
            "/etc/attic/server.toml"
            "--mode"
            "monolithic"
          ];

          volumes = [
            "${attic-config-file}:/etc/attic/server.toml:ro"
            "/var/lib/containers/attic-server/data:/attic/storage"
          ];

          environmentFiles = [ config.sops.secrets."envs/attic".path ];

          extraOptions = [
            "--network=systemd-containers"
            "--ip=10.18.130.108"
          ];
        };
      };
    };
}
