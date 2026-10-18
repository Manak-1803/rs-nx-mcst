{ inputs, ... }: {
  flake.modules.homeManager.btop =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.btop;
    in
    {
      options.rsnxmcst.btop = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.btop = {
          enable = true;
          settings = {
            update_ms = 200;
            proc_tree = true;
            proc_sorting = "cpu lazy";
            io_graph_combined = true;
            save_config_on_exit = false;
          };
        };
      };
    };
}
