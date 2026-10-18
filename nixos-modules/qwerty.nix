{ inputs, ... }: {
  flake.modules.nixos.qwerty =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.qwerty;
    in
    {
      options.rsnxmcst.qwerty = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        services.xserver.xkb = {
          layout = "us";
          variant = "symbolic";
        };

        console = {
          earlySetup = true;
          keyMap = "us";
        };
      };
    };
}
