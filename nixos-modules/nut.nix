{ inputs, ... }: {
  flake.modules.nixos.nut =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.nut;

      primaryPass = builtins.toFile "primary.password" "nut-password";
      secondaryPass = builtins.toFile "secondary.password" "nut-password";
    in
    {
      options.rsnxmcst.nut = {
        enable = inputs.self.lib.enableOpt;

        server = {
          enable = inputs.self.lib.enableOpt;
          address = inputs.self.lib.mkOpt lib.types.str "localhost";
        };
      };

      config = lib.mkIf cfg.enable {
        power.ups = {
          enable = true;
          mode = if cfg.server.enable then "netserver" else "netclient";

          upsmon = {
            monitor.cyberpower =
              if cfg.server.enable then
                {
                  system = "cyberpower@localhost";
                  user = "primary";
                  passwordFile = primaryPass;
                  type = "primary";
                }
              else
                {
                  system = "cyberpower@${cfg.server.address}";
                  user = "secondary";
                  passwordFile = secondaryPass;
                  type = "secondary";
                };

            settings = {
              FINALDELAY = 10;
              SHUTDOWNCMD = "${pkgs.systemd}/bin/systemctl hibernate";
            };
          };
        }
        // lib.optionalAttrs cfg.server.enable {
          ups.cyberpower = {
            description = "CyberPower 1500VA";
            driver = "usbhid-ups";
            port = "auto";

            directives = [
              "pollinterval = 15"
              "override.battery.charge.low = 30"
              "override.battery.runtime.low = 300"
            ];
          };

          upsd.listen = [
            {
              address = "0.0.0.0";
              port = 3493;
            }
          ];

          users = {
            primary = {
              upsmon = "primary";
              passwordFile = primaryPass;
            };

            secondary = {
              upsmon = "secondary";
              passwordFile = secondaryPass;
            };
          };
        };
      };
    };
}
