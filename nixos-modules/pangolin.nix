{ inputs, ... }: {
  flake.modules.nixos.pangolin =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.pangolin;
    in
    {
      options.rsnxmcst.pangolin = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [ pkgs.pangolin-cli ];

        home-manager.sharedModules = [
          ({ config, ... }: {
            rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/pangolin" ];
          })
        ];
      };
    };
}
