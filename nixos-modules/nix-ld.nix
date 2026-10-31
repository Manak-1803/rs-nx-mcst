{ inputs, ... }: {
  flake.modules.nixos.nix-ld =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.nix-ld;
    in
    {
      options.rsnxmcst.nix-ld = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        programs.nix-ld.enable = true;
      };
    };
}
