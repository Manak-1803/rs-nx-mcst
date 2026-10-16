{ inputs, ... }: {
  flake.modules.nixos.amd-gpu =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.amd-gpu;
    in
    {
      options.rsnxmcst.amd-gpu = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        hardware = {
          graphics = {
            enable = true;
            enable32Bit = true;
          };

          amdgpu = {
            initrd.enable = true;
            opencl.enable = true;
          };
        };

        services = {
          lact.enable = true;
          xserver.enable = true;
          xserver.videoDrivers = [ "amdgpu" ];
        };
      };
    };
}
