{ inputs, ... }: {
  flake.modules.nixos.amd-cpu =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.amd-cpu;
    in
    {
      options.rsnxmcst.amd-cpu = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        hardware = {
          cpu.amd.updateMicrocode = true;
          enableRedistributableFirmware = true;
        };

        boot = {
          kernelModules = [
            "zenpower"
            "kvm-amd"
          ];

          kernelParams = [ "amd_pstate=active" ];
          blacklistedKernelModules = [ "k10temp" ];
          extraModulePackages = [ config.boot.kernelPackages.zenpower ];
        };
      };
    };
}
