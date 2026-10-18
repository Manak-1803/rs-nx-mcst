{ inputs, ... }: {
  flake.modules.homeManager.direnv =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.direnv;
    in
    {
      options.rsnxmcst.direnv = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/direnv" ];
      };
    };
}
