{ inputs, ... }: {
  flake.modules.nixos.audio =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.audio;
    in
    {
      options.rsnxmcst.audio = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        security.rtkit.enable = true;

        services.pipewire = {
          enable = true;
          pulse.enable = true;
          jack.enable = true;
          alsa = {
            enable = true;
            support32Bit = true;
          };
        };

        rsnxmcst.user-cain.groups = [ "audio" ];
      };
    };
}
