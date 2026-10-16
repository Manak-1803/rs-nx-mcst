{ inputs, ... }: {
  flake.modules.homeManager.spotify =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.spotify;
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

      options.rsnxmcst.spotify = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.onepunch;
          colorScheme = "dark";

          enabledExtensions = with spicePkgs.extensions; [
            lastfm
            adblock
            shuffle
            loopyLoop
            songStats
            spicyLyrics
            hidePodcasts
          ];
        };

        rsnxmcst.impermanence.directories = [
          "${config.xdg.cacheHome}/spotify"
          "${config.xdg.configHome}/spotify"
        ];
      };
    };
}
