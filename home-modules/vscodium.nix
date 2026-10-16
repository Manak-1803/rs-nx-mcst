{ inputs, ... }: {
  flake.modules.homeManager.vscodium =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.vscodium;

      nixos-options = ''
        let
          flake = builtins.getFlake (toString ./.);
        in
        (flake.inputs.nixpkgs.lib.nixosSystem {
          check = false;
          modules = builtins.attrValues (flake.outputs.modules.nixos or { });
        }).options
      '';

      home-options = ''
        let
          flake = builtins.getFlake (toString ./.);
          pkgs = import flake.inputs.nixpkgs { };
        in
        (flake.inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          check = false;
          modules = [
            {
              home = {
                homeDirectory = "/home/neoth";
                username = "neoth";
                stateVersion =
                  pkgs.lib.lists.last
                    (import (flake.inputs.home-manager.outPath + "/modules/misc/version.nix") {
                      config = { };
                      inherit (pkgs) lib;
                    }).options.home.stateVersion.type.functor.payload.values;
              };
            }
          ]
          ++ builtins.attrValues (flake.outputs.modules.homeManager or { });
        }).options 
      '';
    in
    {
      options.rsnxmcst.vscodium = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.vscodium = {
          enable = true;
          mutableExtensionsDir = false;
          package = pkgs.vscode-with-extensions.override {
            vscode = pkgs.vscodium;
            vscodeExtensions = with pkgs.vscode-extensions; [
              pkief.material-icon-theme
              pkief.material-product-icons
              jnoortheen.nix-ide
              mkhl.direnv
            ];
          };

          profiles.default.userSettings = {
            "editor.formatOnSave" = true;
            "files.autoSave" = "afterDelay";

            "editor.lineNumbers" = "relative";
            "editor.wordBasedSuggestions" = "off";
            "window.menuBarVisibility" = "toggle";
            "workbench.activityBar.location" = "top";

            "editor.fontFamily" = "'JetBrainsMono Nerd Font Mono'";
            "editor.fontLigatures" = true;

            "terminal.integrated.fontFamily" = "'IosevkaTerm Nerd Font Mono'";
            "terminal.integrated.fontLigatures.enabled" = true;

            "workbench.activityBar.experimental.fontFamily" = "'Inter'";
            "workbench.tabs.experimental.fontFamily" = "'Inter'";
            "workbench.statusBar.experimental.fontFamily" = "'Inter'";
            "workbench.sideBar.experimental.fontFamily" = "'Inter'";
            "workbench.experimental.fontFamily" = "'Inter'";
            "workbench.bottomPane.experimental.fontFamily" = "'Inter'";

            "workbench.iconTheme" = "material-icon-theme";
            "workbench.productIconTheme" = "material-product-icons";

            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nixd";
            "nix.serverSettings" = {
              "nixd" = {
                "nixpkgs" = {
                  "expr" = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }";
                };
                "formatting" = {
                  "command" = [ "nixfmt" ];
                };
                "options" = {
                  "nixos" = {
                    "expr" = builtins.replaceStrings [ "\n" "  " ] [ " " "" ] nixos-options;
                  };
                  "home_manager" = {
                    "expr" =
                      builtins.replaceStrings [ "\n" "  " "/home/neoth" "neoth" ] [ " " "" "\${env:HOME}" "\${env:USER}" ]
                        home-options;
                  };
                };
              };
            };
          };
        };

        rsnxmcst.impermanence.directories = [ "${config.xdg.configHome}/VSCodium" ];
      };
    };
}
