{ inputs, ... }: {
  flake.modules.nixos.network-manager =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.network-manager;
    in
    {
      options.rsnxmcst.network-manager = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        networking.networkmanager = {
          enable = true;
          connectionConfig = {
            "connection.mdns" = 2;
          };
        };

        rsnxmcst = {
          user-cain.groups = [ "networkmanager" ];
          impermanence.directories = [ "/etc/NetworkManager/system-connections" ];
        };
      };
    };
}
