{
  flake.modules.generic.terra = { lib, ... }: {
    specialisation.windows.configuration = {
      boot = {
        kernelModules = [
          "vfio"
          "vfio_pci"
          "vfio_iommu_type1"
        ];

        kernelParams = [
          "iommu=pt"
          "amd_iommu=on"
          "kvm.ignore_msrs=1"
          "vfio-pci.ids=1002:7550,1002:ab40"
        ];

        extraModprobeConfig = ''
          softdep amdgpu pre: vfio vfio-pci
        '';
      };

      hardware.amdgpu.initrd.enable = lib.mkForce false;
    };
  };
}
