{ inputs, ... }: {
  flake.modules.nixos.nvidia-prime =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.nvidia-prime;
    in
    {
      options.rsnxmcst.nvidia-prime = {
        enable = inputs.self.lib.enableOpt;
        discreteBus = inputs.self.lib.mkOpt lib.types.str "PCI:0@0:0:0";
        integratedBus = inputs.self.lib.mkOpt lib.types.str "PCI:0@0:0:0";

        iGPU = inputs.self.lib.mkOpt lib.types.str "null";
      };

      config = lib.mkIf cfg.enable {
        assertions = [
          {
            assertion = cfg.iGPU == "amd" || cfg.iGPU == "intel";
            message = ''iGPU must be either "amd" or "intel"'';
          }
        ];

        hardware.nvidia = {
          dynamicBoost.enable = true;

          powerManagement = {
            enable = true;
            finegrained = true;
          };

          prime = {
            offload.enable = true;
            offload.enableOffloadCmd = true;

            nvidiaBusId = cfg.discreteBus;
          }
          // lib.optionalAttrs (cfg.iGPU == "amd") {
            amdgpuBusId = cfg.integratedBus;
          }
          // lib.optionalAttrs (cfg.iGPU == "intel") {
            intelBusId = cfg.integratedBus;
          };
        };
      };
    };
}
