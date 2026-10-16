{ inputs, ... }: {
  flake.modules.nixos.impermanence =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.impermanence;
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      options.rsnxmcst.impermanence = {
        enable = inputs.self.lib.enableOpt;
        storagePath = inputs.self.lib.mkOpt lib.types.str "/persist";

        directories = inputs.self.lib.mkOpt (
          with lib.types; listOf (coercedTo str (path: { directory = path; }) attrs)
        ) [ ];

        files = inputs.self.lib.mkOpt (
          with lib.types; listOf (coercedTo str (path: { file = path; }) attrs)
        ) [ ];
      };

      config = lib.mkIf cfg.enable {
        environment.persistence."${cfg.storagePath}" = {
          inherit (cfg) directories files;
          hideMounts = true;
        };

        rsnxmcst.impermanence = {
          directories = [
            "/var/log"
            "/var/lib/nixos"
          ];

          files = [ "/etc/machine-id" ];
        };
      };
    };
}
