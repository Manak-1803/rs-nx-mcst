{ inputs, ... }: {
  flake.modules.nixos.containers =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.containers;
    in
    {
      options.rsnxmcst.containers = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        networking = {
          nat = {
            enable = true;
            enableIPv6 = true;
            internalInterfaces = [ "containers" ];

            extraCommands = ''
              iptables -t nat -A POSTROUTING -s 10.18.0.0/16 ! -o containers -j MASQUERADE
            '';
          };

          networkmanager.unmanaged = [
            "containers"
            "interface-name:vb-*"
            "interface-name:veth*"
          ];

          firewall.trustedInterfaces = [ "containers" ];
        };

        systemd.network = {
          enable = true;
          wait-online.enable = false;

          netdevs = {
            "20-containers" = {
              netdevConfig = {
                Kind = "bridge";
                Name = "containers";
              };
            };
          };

          networks = {
            "40-containers" = {
              matchConfig.Name = "containers";
              address = [ "10.18.165.111/16" ];
            };
          };
        };

        systemd.services.init-podman-containers-network = {
          description = "Create Podman network on systemd 'containers' bridge";

          after = [
            "podman.service"
            "systemd-networkd.service"
          ];

          wants = [
            "podman.service"
            "systemd-networkd.service"
          ];

          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = pkgs.writeShellScript "init-podman-net" ''
              # Ensure the parent interface is active
              ${pkgs.iproute2}/bin/ip link set dev containers up

              # Create network if missing
              if ! ${pkgs.podman}/bin/podman network exists systemd-containers >/dev/null 2>&1; then
                ${pkgs.podman}/bin/podman network create \
                  --driver bridge \
                  --opt mode=unmanaged \
                  --opt com.docker.network.bridge.name=containers \
                  --subnet 10.18.0.0/16 \
                  --gateway 10.18.165.111 \
                  systemd-containers
              fi
            '';
          };
        };
      };
    };
}
