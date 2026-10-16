{ inputs, ... }: {
  flake.modules.homeManager.lazygit =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.lazygit;
    in
    {
      options.rsnxmcst.lazygit = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.lazygit = {
          enable = true;
          settings = {
            gui = {
              nerdFontsVersion = "3";
            };
          };
        };
      };
    };
}
