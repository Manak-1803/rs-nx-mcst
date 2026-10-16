{ inputs, ... }: {
  flake.modules.nixos.tpm =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.tpm;
    in
    {
      options.rsnxmcst.tpm = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        security.tpm2 = {
          enable = true;
          pkcs11.enable = true;
          tctiEnvironment.enable = true;
        };
      };
    };
}
