{ inputs, ... }: {
  flake.modules.nixos.locale =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.locale;
    in
    {
      options.rsnxmcst.locale = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        time.timeZone = "Asia/Kolkata";
        i18n.defaultLocale = "en_US.UTF-8";

        i18n.extraLocaleSettings = {
          LC_ADDRESS = "en_IN";
          LC_IDENTIFICATION = "en_IN";
          LC_MEASUREMENT = "en_IN";
          LC_MONETARY = "en_IN";
          LC_NAME = "en_IN";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_IN";
          LC_TELEPHONE = "en_IN";
          LC_TIME = "en_IN";
        };
      };
    };
}
