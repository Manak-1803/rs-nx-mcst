{ inputs, ... }: {
  flake.modules.homeManager.ssh =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.ssh;
    in
    {
      options.rsnxmcst.ssh = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;

          settings = {
            "*" = {
              Compression = false;
              ForwardAgent = false;
              VisualHostKey = "yes";
              AddKeysToAgent = "confirm";

              ServerAliveInterval = 30;
              ServerAliveCountMax = 3;

              ControlMaster = "auto";
              ControlPersist = "no";
              ControlPath = "~/.ssh/master-%r@%n:%p";
            };
          };
        };

        services.ssh-agent.enable = true;

        rsnxmcst.impermanence.files = [
          ".ssh/known_hosts"
          ".ssh/id_ed25519"
          ".ssh/id_ed25519.pub"
          ".ssh/id_ed25519_sk"
          ".ssh/id_ed25519_sk.pub"
        ];
      };
    };
}
