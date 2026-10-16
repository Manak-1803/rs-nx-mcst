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
        externalNAT = inputs.self.lib.mkOpt lib.types.str "lo";
      };

      config = lib.mkIf cfg.enable {
        networking = {
          nat = {
            enable = true;
            internalInterfaces = [ "containers" ];
            externalInterface = cfg.externalNAT;
          };

          networkmanager.unmanaged = [
            "containers"
            "interface-name:ve-*"
            "interface-name:veth*"
          ];
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
              networkConfig = {
                ConfigureWithoutCarrier = true;
              };
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
                  --driver ipvlan \
                  --opt parent=containers \
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
