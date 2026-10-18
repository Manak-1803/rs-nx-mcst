{ inputs, ... }: {
  flake.modules.nixos.libvirtd =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.libvirtd;
    in
    {
      imports = [ inputs.nixvirt.nixosModules.default ];

      options.rsnxmcst.libvirtd = {
        enable = inputs.self.lib.enableOpt;
        volumes = inputs.self.lib.mkOpt (with lib.types; listOf attrs) [ ];
      };

      config = lib.mkIf cfg.enable {
        virtualisation.libvirt = {
          enable = true;
          swtpm.enable = true;

          connections."qemu:///system" = {
            pools = lib.singleton {
              inherit (cfg) volumes;
              active = true;
              definition = inputs.nixvirt.lib.pool.writeXML {
                name = "NixOS Pool";
                uuid = "21532944-2d33-41f5-bcae-cc6221fa398c";
                type = "dir";
                target.path = "/var/lib/libvirt/images";
              };
            };

            networks = lib.singleton {
              active = true;
              definition = inputs.nixvirt.lib.network.writeXML (
                inputs.nixvirt.lib.network.templates.bridge {
                  uuid = "43386a18-b3b5-49c1-8bf7-ab61c1ddb91b";
                  name = "Bridge Network";
                  bridge_name = "libvirt";
                  subnet_byte = 18;
                }
              );
            };
          };
        };

        rsnxmcst = {
          user-cain.groups = [ "libvirtd" ];
          impermanence.directories = [
            {
              directory = "/var/lib/swtpm-localca";
              user = "tss";
              group = "tss";
              mode = "0770";
            }
          ];
        };
      };
    };
}
