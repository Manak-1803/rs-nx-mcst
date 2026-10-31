{ inputs, ... }: {
  flake.modules.homeManager.git =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.git;
    in
    {
      options.rsnxmcst.git = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.git = {
          enable = true;
          settings = {
            pull.rebase = true;
            init.defaultBranch = "main";
            branch.autosetuprebase = "always";

            user = {
              email = "arindamshrivastava@proton.me";
              name = "Manak1803";
            };

            alias = {
              push-rebase = "!git pull --rebase && git push";
            };
          };

          signing = {
            format = "ssh";
            signByDefault = true;
            key = "~/.ssh/id_ed25519_sk.pub";
          };
        };
      };
    };
}
