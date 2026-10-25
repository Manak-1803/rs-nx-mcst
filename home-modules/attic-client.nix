{ inputs, ... }: {
  flake.modules.homeManager.attic-client =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.attic-client;
    in
    {
      options.rsnxmcst.attic-client = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        sops.secrets.attic-token = { };

        programs.attic-client = {
          enable = true;
          watchStore = [ "cache" ];
          settings = {
            default-server = "rsnxmcst";
            servers.rsnxmcst = {
              endpoint = "https://cache.rsnxmcst.dedyn.io";
              token-file = config.sops.secrets.attic-token.path;
            };
          };
        };
      };
    };
}
