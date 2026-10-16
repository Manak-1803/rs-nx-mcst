{ inputs, ... }: {
  flake.modules.nixos.bluetooth =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.bluetooth;
    in
    {
      options.rsnxmcst.bluetooth = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General = {
              Experimental = true;
              FastConnectable = true;
            };
          };
        };

        rsnxmcst.impermanence.directories = [ "/var/lib/bluetooth" ];
      };
    };
}
