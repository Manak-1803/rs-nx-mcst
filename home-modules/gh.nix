{ inputs, ... }: {
  flake.modules.homeManager.gh =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.gh;
    in
    {
      options.rsnxmcst.gh = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.gh = {
          enable = true;
          settings.git_protocol = "ssh";
        };

        rsnxmcst.impermanence.files = [ "${config.xdg.configHome}/gh/hosts.yaml" ];
      };
    };
}
