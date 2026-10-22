{ inputs, ... }: {
  flake.modules.nixos.minecraft-server =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.minecraft-server;

      enabled = builtins.any (x: x) (builtins.attrValues cfg);

      services-params = {
        after = [
          "init-podman-containers-network.service"
          "podman-packwiz-server.service"
        ];

        requires = [
          "init-podman-containers-network.service"
          "podman-packwiz-server.service"
        ];
      };
    in
    {
      options.rsnxmcst.minecraft-server = {
        crator = inputs.self.lib.enableOpt;
      };

      config = lib.mkMerge [
        (lib.mkIf enabled {
          systemd.services.podman-packwiz-server = {
            after = [ "init-podman-containers-network.service" ];
            requires = [ "init-podman-containers-network.service" ];
          };

          sops.secrets.packwiz-ssh = { };
          networking.firewall.allowedTCPPorts = [ 8000 ];

          virtualisation.oci-containers.containers.packwiz-server = {
            image = "docker.io/library/alpine:latest";
            ports = [ ];

            volumes = [
              "${config.sops.secrets.packwiz-ssh.path}:/id_ed25519:ro"
            ];

            environment = {
              REPO_URL = "git@github.com:Manak-1803/rsnx-mc-st.git";
            };

            cmd = [
              "sh"
              "-c"
              ''
                apk add --no-cache git openssh-client python3

                mkdir -p /root/.ssh
                chmod 700 /root/.ssh
                cp /id_ed25519 /root/.ssh
                chmod 600 /root/.ssh/id_ed25519

                export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

                mkdir -p /srv/packwiz
                git clone "$REPO_URL" /srv/packwiz

                exec python3 -m http.server 80 --directory /srv/packwiz
              ''
            ];

            extraOptions = [
              "--network=systemd-containers"
              "--ip=10.18.31.165"
            ];
          };
        })

        (lib.mkIf cfg.crator {
          systemd.services.podman-minecraft-crator = {
            inherit (services-params) after requires;
          };

          networking.firewall = {
            allowedTCPPorts = [ 25565 ];
            allowedUDPPorts = [ 24454 ];
          };

          virtualisation.oci-containers.containers.minecraft-crator = {
            image = "docker.io/itzg/minecraft-server:latest";
            ports = [ ];

            volumes = [
              "/var/lib/containers/minecraft/crator:/data"
            ];

            environment = {
              EULA = "TRUE";
              MEMORY = "4096M";
              VERSION = "1.21.1";

              TYPE = "NEOFORGE";
              NEOFORGE_VERSION = "21.1.264";
              PACKWIZ_URL = "http://10.18.31.165/crator/pack.toml";
              JVM_XX_OPTS = "-XX:+UseZGC -XX:+ZGenerational";

              ALLOW_FLIGHT = "true";
              DIFFICULTY = "hard";
              OPS = "Manak_1803";
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
