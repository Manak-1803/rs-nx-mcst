{ inputs, ... }: {
  flake.modules.nixos.nix =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.nix;
      flakes = lib.filterAttrs (name: value: value ? outputs) inputs;
    in
    {
      options.rsnxmcst.nix = {
        enable = inputs.self.lib.enableOpt;
        substituters = inputs.self.lib.mkOpt (with lib.types; attrsOf str) { };
      };

      config = lib.mkIf cfg.enable {
        sops.secrets.nix-access-tokens = { };

        nix = {
          channel.enable = false;
          registry = builtins.mapAttrs (_: value: { flake = value; }) flakes;
          nixPath = lib.mapAttrsToList (name: value: "${name}=${value.to.path}") config.nix.registry;

          optimise = {
            automatic = true;
            dates = "weekly";
            persistent = true;
          };

          extraOptions = ''
            !include ${config.sops.secrets.nix-access-tokens.path}
          '';

          settings = {
            experimental-features = [
              "flakes"
              "nix-command"
              "pipe-operators"
            ];

            trusted-users = [
              "root"
              "@wheel"
            ];

            fallback = true;
            min-free = 128 * 1024 * 1024;
            max-free = 1024 * 1024 * 1024;
            download-buffer-size = 1024 * 1024 * 1024;

            substituters = builtins.attrNames cfg.substituters;
            trusted-public-keys = builtins.attrValues cfg.substituters;
          };
        };
      };
    };
}
