{
  flake.modules.generic.nocturne =
    { lib, ... }:
    {
      specialisation.windows.configuration = {
        boot = {
          kernelModules = [
            "vfio"
            "vfio_iommu_type1"
            "vfio_pci"
          ];

          kernelParams = [
            "iommu=pt"
            "amd_iommu=on"
            "vfio-pci.ids=10de:2860,10de:22bd"
          ];

          blacklistedKernelModules = [
            "nouveau"
            "nvidia"
            "nvidia_drm"
            "nvidia_uvm"
            "nvidia_modeset"
          ];

          extraModprobeConfig = ''
            options kvm ignore_msrs=1
          '';
        };

        services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];
      };
    };
}
