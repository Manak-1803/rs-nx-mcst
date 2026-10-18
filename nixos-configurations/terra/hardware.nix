{ inputs, ... }: {
  flake.modules.generic.terra = {
    imports = [ inputs.disko.nixosModules.disko ];

    rsnxmcst = {
      amd-cpu.enable = true;
      amd-gpu.enable = true;
      audio.enable = true;
      bluetooth.enable = true;
    };

    boot.initrd.availableKernelModules = [
      "nvme"
      "ahci"
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
      device = "/dev/disk/by-id/nvme-WD_Blue_SN580_2TB_24144A803567";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "2G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          swap = {
            size = "56G";
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
