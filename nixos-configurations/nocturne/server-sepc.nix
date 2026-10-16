{
  flake.modules.generic.nocturne = { lib, ... }: {
    specialisation.server.configuration = {
      rsnxmcst = {
        nut.enable = true;
        nut.server.enable = true;

        cloudflare-warp.enable = lib.mkForce false;
        cosmic.enable = lib.mkForce false;
        steam.enable = lib.mkForce false;
        virt-manager.enable = lib.mkForce false;

        audio.enable = lib.mkForce false;
        bluetooth.enable = lib.mkForce false;
      };

      home-manager.users.cain = {
        rsnxmcst = {
          core.graphical = lib.mkForce false;
        };
      };

      services = {
        thermald.enable = true;
        xserver.enable = lib.mkForce false;

        logind.settings.Login = {
          HandlePowerKey = "poweroff";
          HandlePowerKeyLongPress = "ignore";

          HandleRebootKey = "reboot";
          HandleRebootKeyLongPress = "ignore";

          HandleSuspendKey = "suspend";
          HandleSuspendKeyLongPress = "hibernate";

          HandleHibernateKey = "hibernate";
          HandleHibernateKeyLongPress = "ignore";

          HandleLidSwitch = "ignore";
          HandleLidSwitchExternalPower = "ignore";
          HandleLidSwitchDocked = "ignore";
          LidSwitchIgnoreInhibited = "yes";

          IdleAction = "ignore";
        };
      };

      boot = {
        kernelModules = [ "ideapad_laptop" ];
        kernelParams = [ "consoleblank=60" ];
      };

      systemd.services.lenovo-conservation-mode = {
        description = "Enable Lenovo Battery Conservation Mode (24/7 Plugged-in Health)";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };

        script = ''
          # Find Lenovo ideapad platform node and set conservation_mode to 1
          for path in /sys/bus/platform/drivers/ideapad_laptop/VPC2004:*/conservation_mode; do
            if [ -f "$path" ]; then
              echo 1 > "$path"
            fi
          done
        '';
      };
    };
  };
}
