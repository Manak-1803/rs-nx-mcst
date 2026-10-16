{ inputs, ... }: {
  flake.modules.homeManager.fonts =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.fonts;
    in
    {
      options.rsnxmcst.fonts = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        fonts.fontconfig = {
          enable = true;
          defaultFonts = {
            monospace = [ "JetBrainsMono Nerd Font Mono" ];
            sansSerif = [ "Inter" ];
          };
          antialiasing = true;
          hinting = "full";
          subpixelRendering = "rgb";
        };

        home.packages = with pkgs; [
          inter
          nerd-fonts.jetbrains-mono
          nerd-fonts.iosevka-term
        ];
      };
    };
}
