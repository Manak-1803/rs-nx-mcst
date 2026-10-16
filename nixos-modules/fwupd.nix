{ inputs, ... }: {
  flake.modules.nixos.fwupd =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.fwupd;
    in
    {
      options.rsnxmcst.fwupd = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        services.fwupd.enable = true;
      };
    };
}
