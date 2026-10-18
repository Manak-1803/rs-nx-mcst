{ inputs, ... }: {
  flake.modules.nixos.newt =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.newt;
    in
    {
      options.rsnxmcst.newt = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        sops.secrets."envs/newt" = {
          sopsFile = inputs.secrets + "/${config.networking.hostName}.yaml";
        };

        services.newt = {
          enable = true;
          environmentFile = config.sops.secrets."envs/newt".path;
          settings.endpoint = "https://pangolin.rsnxmcst.dedyn.io";
        };
      };
    };
}
