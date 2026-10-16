{ inputs, ... }: {
  flake.modules.generic.nocturne = {
    imports = [ inputs.disko.nixosModules.disko ];

    rsnxmcst = {
      amd-cpu.enable = true;
      amd-gpu.enable = true;
      audio.enable = true;
      bluetooth.enable = true;
      nvidia-gpu.enable = true;
      nvidia-prime.enable = true;

      nvidia-prime.iGPU = "amd";
      nvidia-prime.discreteBus = "PCI:1@0:0:0";
      nvidia-prime.integratedBus = "PCI:6@0:0:0";
    };

    boot.initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "usbhid"
      "uas"
      "sd_mod"
    ];

    fileSystems."/nix".neededForBoot = true;
    fileSystems."/persist".neededForBoot = true;

    disko.devices.nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=25%"
          "mode=755"
        ];
      };
    };

    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEJ9X115N_AMCCN00671060CN6H";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "48G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };

          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "@persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "@nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };

                "@containers" = {
                  mountpoint = "/var/lib/containers";
                  mountOptions = [
                    "nodatacow"
                    "noatime"
                  ];
                };

                "@libvirt" = {
                  mountpoint = "/var/lib/libvirt/images";
                  mountOptions = [
                    "nodatacow"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
