{ inputs, ... }: {
  flake.modules.nixos.sudo =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.sudo;
    in
    {
      options.rsnxmcst.sudo = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        security.sudo = {
          enable = true;
          extraConfig = ''
            Defaults insults
            Defaults lecture="never"
          '';
        };
      };
    };
}
