{ inputs, ... }: {
  flake.modules.nixos.systemd-boot =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.systemd-boot;
    in
    {
      options.rsnxmcst.systemd-boot = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        boot.loader = {
          timeout = 5;
          efi.canTouchEfiVariables = true;
          systemd-boot = {
            enable = true;
            editor = false;
            consoleMode = "max";
            configurationLimit = 8;
          };
        };
      };
    };
}
