{ self, inputs, ... }: {
  flake.modules.nixos.nixpkgs =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.nixpkgs;
    in
    {
      options.rsnxmcst.nixpkgs = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        nixpkgs = {
          config.allowUnfree = true;
          overlays = builtins.attrValues self.overlays;
        };
      };
    };
}
