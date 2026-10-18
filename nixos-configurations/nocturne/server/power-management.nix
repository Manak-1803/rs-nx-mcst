{
  flake.modules.generic.nocturne = {
    specialisation.server.configuration = {
      services = {
        thermald.enable = true;

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
