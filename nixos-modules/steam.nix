{ inputs, ... }: {
  flake.modules.nixos.steam =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.steam;
    in
    {
      options.rsnxmcst.steam = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.steam = {
          enable = true;
          package = pkgs.steam.override {
            extraEnv = {
              STEAM_FORCE_DESKTOPUI_SCALING = 2;
            };
          };
        };

        home-manager.sharedModules = [
          ({ config, ... }: {
            rsnxmcst.impermanence.directories = [
              "/.steam"
              "${config.xdg.dataHome}/Steam"
            ];
          })
        ];
      };
    };
}
