{ inputs, ... }: {
  flake.modules.nixos.cloudflare-warp =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.cloudflare-warp;
    in
    {
      options.rsnxmcst.cloudflare-warp = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        services.cloudflare-warp = {
          enable = true;
          openFirewall = true;
        };

        rsnxmcst.impermanence.directories = [ "/var/lib/cloudflare-warp" ];
      };
    };
}
