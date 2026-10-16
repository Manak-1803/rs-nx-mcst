{ inputs, ... }: {
  flake.modules.nixos.nh =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.nh;
    in
    {
      options.rsnxmcst.nh = {
        enable = inputs.self.lib.enableOpt;
        flakePath = inputs.self.lib.mkOpt lib.types.str "null";
      };

      config = lib.mkIf cfg.enable {
        programs.nh = {
          enable = true;
          flake = cfg.flakePath;
          clean = {
            enable = true;
            dates = "weekly";
            extraArgs = "--keep 8 --keep-since 30d";
          };
        };
      };
    };
}
