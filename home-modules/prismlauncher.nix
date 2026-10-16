{ inputs, ... }: {
  flake.modules.homeManager.prismlauncher =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.prismlauncher;
    in
    {
      options.rsnxmcst.prismlauncher = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        home.packages = [ pkgs.prismlauncher ];
        rsnxmcst.impermanence.directories = [ "${config.xdg.dataHome}/PrismLauncher" ];
      };
    };
}
