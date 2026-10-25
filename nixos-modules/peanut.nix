{ inputs, ... }: {
  flake.modules.nixos.peanut =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.peanut;
      enabled = cfg.enable && config.rsnxmcst.nut.server.enable;
    in
    {
      options.rsnxmcst.peanut = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf enabled {
        systemd.services.podman-peanut = {
          after = [ "init-podman-containers-network.service" ];
          requires = [ "init-podman-containers-network.service" ];
        };

        virtualisation.oci-containers.containers.peanut = {
          image = "docker.io/brandawg93/peanut:latest";
          ports = [ ];

          volumes = [
            "/var/lib/containers/peanut:/config"
          ];

          environment = {
            WEB_HOST = "10.18.122.8";
            WEB_PORT = "8000";
            AUTH_DISABLED = "true";
          };

          extraOptions = [
            "--network=systemd-containers"
            "--ip=10.18.122.8"
          ];
        };
      };
    };
}
