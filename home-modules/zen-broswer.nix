{ inputs, ... }: {
  flake.modules.homeManager.zen-browser =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.zen-browser;
    in
    {
      imports = [ inputs.zen-browser.homeModules.beta ];

      options.rsnxmcst.zen-browser = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.zen-browser = {
          enable = true;
          setAsDefaultBrowser = true;

          policies = {
            DisablePocket = true;
            DisableAppUpdate = true;
            DisableTelemetry = true;
            OfferToSaveLogins = false;
            NoDefaultBookmarks = true;
            DisableFirefoxStudies = true;
            DisableFeedbackCommands = true;
            DontCheckDefaultBrowser = true;

            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };
          };

          profiles.default = { };
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/zen/default" ];
      };
    };
}
