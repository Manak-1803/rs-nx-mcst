{ inputs, ... }: {
  flake.modules.nixos.surge =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.surge;
    in
    {
      options.rsnxmcst.surge = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.surge-downloader ];

        systemd.services.surge-downloader = {
          description = "Surge Download Manager";

          wantedBy = [ "multi-user.target" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];

          serviceConfig = {
            ExecStart = "${pkgs.surge-downloader}/bin/surge server start";

            Restart = "on-failure";
            RestartSec = "5s";
          };
        };
      };
    };
}
