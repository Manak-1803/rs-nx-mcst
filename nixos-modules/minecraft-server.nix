{ inputs, ... }: {
  flake.modules.nixos.minecraft-server =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.minecraft-server;
    in
    {
      options.rsnxmcst.minecraft-server = {
        crator = inputs.self.lib.enableOpt;
      };

      config = lib.mkMerge [
        (lib.mkIf cfg.crator {
          systemd.services.podman-minecraft-crator = {
            after = [ "init-podman-containers-network.service" ];
            requires = [ "init-podman-containers-network.service" ];
          };

          networking.firewall = {
            allowedTCPPorts = [ 25565 ];
            allowedUDPPorts = [ 24454 ];
          };

          virtualisation.oci-containers.containers.minecraft-crator = {
            image = "docker.io/itzg/minecraft-server:latest";

            volumes = [
              "/var/lib/containers/minecraft/crator:/data"
              "${inputs.rsnx-mc-st}/crator:/packwiz"
            ];

            environment = {
              EULA = "TRUE";
              MEMORY = "4096M";
              VERSION = "1.21.1";

              TYPE = "NEOFORGE";
              NEOFORGE_VERSION = "21.1.264";
              PACKWIZ_URL = "file:///packwiz/pack.toml";
              JVM_XX_OPTS = "-XX:+UseZGC -XX:+ZGenerational";

              ALLOW_FLIGHT = "true";
            };

            extraOptions = [
              "--network=systemd-containers"
              "--ip=10.18.65.37"
              "--interactive"
              "--tty"
            ];
          };
        })
      ];
    };
}
