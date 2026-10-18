{
  flake.modules.generic.terra =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      specialisation.windows.configuration = {
        boot = {
          extraModulePackages = [ config.boot.kernelPackages.kvmfr ];
          initrd.kernelModules = [ "kvmfr" ];
          kernelParams = [ "kvmfr.static_size_mb=64" ];
        };

        services.udev.packages = lib.singleton (
          pkgs.writeTextFile {
            name = "kvmfr";
            text = ''
              SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
            '';
            destination = "/etc/udev/rules.d/70-kvmfr.rules";
          }
        );

        virtualisation.libvirtd.qemu = {
          verbatimConfig = ''
            namespaces = []
            cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom", "/dev/ptmx", 
              "/dev/kvm", "/dev/kqemu", "/dev/rtc","/dev/hpet", 
              "/dev/vfio/vfio", "/dev/kvmfr0"
            ]
          '';
        };

        home-manager.users.cain = {
          programs.looking-glass-client = {
            enable = true;
            settings = {
              input = {
                escapeKey = "KEY_RIGHTALT";
                rawMouse = "yes";
                grabKeyboard = "yes";
              };
            };
          };
        };
      };
    };
}
