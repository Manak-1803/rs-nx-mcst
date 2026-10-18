{
  flake.modules.generic.nocturne =
    { lib, ... }:
    {
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
            "vfio-pci.ids=10de:2860,10de:22bd"
          ];

          blacklistedKernelModules = [
            "nouveau"
            "nvidia"
            "nvidia_drm"
            "nvidia_uvm"
            "nvidia_modeset"
          ];
        };

        services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];
      };
    };
}
