{ inputs, ... }: {
  flake.modules.homeManager.secrets =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.secrets;
    in
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      options.rsnxmcst.secrets = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        sops = {
          defaultSopsFile = inputs.secrets + "/base.yaml";
          age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
        };
      };
    };
}
