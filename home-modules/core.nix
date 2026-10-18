{ inputs, ... }: {
  flake.modules.homeManager.core =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.core;
    in
    {
      options.rsnxmcst.core = {
        enable = inputs.self.lib.enableOpt;
        graphical = inputs.self.lib.enableOpt;
      };

      config = lib.mkMerge [
        (lib.mkIf cfg.enable {
          rsnxmcst = {
            direnv.enable = true;
            gh.enable = true;
            git.enable = true;
            secrets.enable = true;
            ssh.enable = true;
            xdg-directories.enable = true;
          };

          programs.home-manager.enable = true;
        })

        (lib.mkIf cfg.graphical {
          rsnxmcst = {
            fonts.enable = true;
            lazygit.enable = true;
            vscodium.enable = true;
          };
        })
      ];
    };
}
