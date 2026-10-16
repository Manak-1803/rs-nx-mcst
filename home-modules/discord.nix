{ inputs, ... }: {
  flake.modules.homeManager.discord =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.discord;
    in
    {
      options.rsnxmcst.discord = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.discord = {
          enable = true;
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/discord" ];
      };
    };
}
