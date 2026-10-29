{ inputs, ... }: {
  flake.modules.nixos.cosmic =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.cosmic;
    in
    {
      options.rsnxmcst.cosmic = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        services = {
          desktopManager.cosmic.enable = true;
          displayManager.cosmic-greeter.enable = true;
          gnome.gnome-keyring.enable = false;
        };

        environment = {
          sessionVariables = {
            NIXOS_OZONE_WL = "1";
            COSMIC_DATA_CONTROL_ENABLED = "1";
            COSMIC_DISABLE_DIRECT_SCANOUT = "true";
          };

          systemPackages = with pkgs; [
            wl-clipboard
          ];
        };

        home-manager.sharedModules = [
          ({ config, ... }: {
            home.file.".config/cosmic-initial-setup-done".text = "";
            rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/cosmic" ];
          })
        ];
      };
    };
}
