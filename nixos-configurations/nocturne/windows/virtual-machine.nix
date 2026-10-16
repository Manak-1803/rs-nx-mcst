{ inputs, ... }: {
  flake.modules.generic.nocturne =
    { lib, pkgs, ... }:
    let
      # 1. Create a helper shell script that runs your desired virsh command
      windowsVmScript = pkgs.writeShellScriptBin "start-windows-vm" ''
        # Start the VM via qemu:///system
        ${pkgs.libvirt}/bin/virsh -c qemu:///system start Windows
      '';

      # 2. Define the desktop application entry
      windowsDesktopItem = pkgs.makeDesktopItem {
        name = "windows-vm";
        desktopName = "Windows VM";
        comment = "Boot the Windows KVM guest via libvirt";
        exec = "${windowsVmScript}/bin/start-windows-vm";
        icon = ./logo.svg;
        terminal = false;
        categories = [
          "System"
          "Emulator"
        ];
      };
    in
    {
      specialisation.windows.configuration = {
        virtualisation.libvirt.connections."qemu:///system" = {
          domains = lib.singleton {
            definition = ./Windows.xml;
          };
        };

        rsnxmcst.libvirtd.volumes = lib.singleton {
          present = true;
          definition = inputs.nixvirt.lib.volume.writeXML {
            name = "Windows.img";
            capacity = {
              count = 128;
              unit = "GiB";
            };
          };
        };

        environment.systemPackages = [
          windowsDesktopItem
        ];
      };
    };
}
