{ inputs, ... }: {
  flake.modules.homeManager.xdg-directories =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.xdg-directories;
    in
    {
      options.rsnxmcst.xdg-directories = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        xdg = {
          enable = true;

          cacheHome = "${config.home.homeDirectory}/.cache";
          configHome = "${config.home.homeDirectory}/.config";

          binHome = "${config.home.homeDirectory}/.local/bin";
          dataHome = "${config.home.homeDirectory}/.local/share";
          stateHome = "${config.home.homeDirectory}/.local/state";

          userDirs = {
            enable = true;

            desktop = "${config.home.homeDirectory}/Desktop";
            documents = "${config.home.homeDirectory}/Documents";
            download = "${config.home.homeDirectory}/Downloads";
            music = "${config.home.homeDirectory}/Music";
            pictures = "${config.home.homeDirectory}/Pictures";
            projects = "${config.home.homeDirectory}/Projects";
            publicShare = "${config.home.homeDirectory}/Public";
            templates = "${config.home.homeDirectory}/Templates";
            videos = "${config.home.homeDirectory}/Videos";
          };
        };

        rsnxmcst.impermanence.directories = [
          config.xdg.userDirs.desktop
          config.xdg.userDirs.documents
          config.xdg.userDirs.download
          config.xdg.userDirs.music
          config.xdg.userDirs.pictures
          config.xdg.userDirs.projects
          config.xdg.userDirs.publicShare
          config.xdg.userDirs.templates
          config.xdg.userDirs.videos
        ];
      };
    };
}
