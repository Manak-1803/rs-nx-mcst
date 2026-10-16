{ inputs, ... }: {
  flake.modules.nixos.virt-manager =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.virt-manager;
    in
    {
      options.rsnxmcst.virt-manager = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.virt-manager.enable = true;
      };
    };
}
