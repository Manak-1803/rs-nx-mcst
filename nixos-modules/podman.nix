{ inputs, ... }: {
  flake.modules.nixos.podman =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.podman;
    in
    {
      options.rsnxmcst.podman = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        virtualisation = {
          containers.enable = true;

          podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings = {
              dns_enabled = true;
            };
          };
        };

        environment.systemPackages = with pkgs; [
          podman-tui
          podman-compose
        ];

        rsnxmcst.user-cain.groups = [ "podman" ];

        home-manager.sharedModules = [
          ({ config, ... }: {
            rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/containers" ];
          })
        ];
      };
    };
}
