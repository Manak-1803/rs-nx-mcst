{ inputs, ... }: {
  flake.modules.nixos.nvidia-gpu =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.nvidia-gpu;
    in
    {
      options.rsnxmcst.nvidia-gpu = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;
          };

          nvidia = {
            open = true;
            nvidiaSettings = true;
            nvidiaPersistenced = true;
            modesetting.enable = true;
            package = config.boot.kernelPackages.nvidiaPackages.latest;
          };
        };

        services = {
          xserver.enable = true;
          xserver.videoDrivers = [ "nvidia" ];
        };
      };
    };
}
