{ inputs, ... }: {
  flake.modules.nixos.jellyfin =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.jellyfin;
    in
    {
      options.rsnxmcst.jellyfin = {
        enable = inputs.self.lib.enableOpt;
        enableNvidia = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        containers.jellyfin = inputs.self.lib.mkContainer {
          address = "10.18.197.89/16";

          bindMounts = {
            "/var/lib/jellyfin" = {
              hostPath = "/var/lib/jellyfin";
              isReadOnly = false;
            };

            #Media Path
            "/media" = {
              hostPath = "/media/jellyfin";
              isReadOnly = true;
            };
          }
          // lib.optionalAttrs cfg.enableNvidia {
            # NVIDIA Passthrough
            "/dev/dri" = {
              hostPath = "/dev/dri";
              isReadOnly = false;
            };
            "/dev/nvidia0" = {
              hostPath = "/dev/nvidia0";
              isReadOnly = false;
            };
            "/dev/nvidiactl" = {
              hostPath = "/dev/nvidiactl";
              isReadOnly = false;
            };
            "/dev/nvidia-modeset" = {
              hostPath = "/dev/nvidia-modeset";
              isReadOnly = false;
            };
            "/dev/nvidia-uvm" = {
              hostPath = "/dev/nvidia-uvm";
              isReadOnly = false;
            };
            "/dev/nvidia-uvm-tools" = {
              hostPath = "/dev/nvidia-uvm-tools";
              isReadOnly = false;
            };
            "/run/opengl-driver" = {
              hostPath = "/run/opengl-driver";
              isReadOnly = false;
            };
          };

          allowedDevices = lib.optionals cfg.enableNvidia [
            {
              modifier = "rwm";
              node = "/dev/dri/card0";
            }
            {
              modifier = "rwm";
              node = "/dev/dri/renderD129";
            }
            {
              modifier = "rwm";
              node = "/dev/nvidia0";
            }
            {
              modifier = "rwm";
              node = "/dev/nvidiactl";
            }
            {
              modifier = "rwm";
              node = "/dev/nvidia-modeset";
            }
            {
              modifier = "rwm";
              node = "/dev/nvidia-uvm";
            }
            {
              modifier = "rwm";
              node = "/dev/nvidia-uvm-tools";
            }
          ];

          module = {
            services.jellyfin = {
              enable = true;
              openFirewall = true;
              forceEncodingConfig = true;

              transcoding = {
                enableHardwareEncoding = cfg.enableNvidia;

                hardwareEncodingCodecs = {
                  av1 = true;
                  hevc = true;
                };

                hardwareDecodingCodecs = {
                  av1 = true;
                  vc1 = true;
                  vp8 = true;
                  vp9 = true;
                  h264 = true;
                  hevc = true;
                  mpeg2 = true;
                  hevc10bit = true;
                  hevcRExt10bit = true;
                  hevcRExt12bit = true;
                };
              };

              hardwareAcceleration = {
                enable = cfg.enableNvidia;
                type = "nvenc";
                device = "/dev/dri/renderD129";
              };
            };
          };
        };

        rsnxmcst.impermanence.directories = [
          "/var/lib/jellyfin"

          {
            directory = "/media/jellyfin";
            user = "root";
            group = "wheel";
            mode = "2775";
          }
        ];

        system.activationScripts.jellyfin-acls = ''
          mkdir -p /media/jellyfin
          chown root:wheel /media/jellyfin
          chmod 2775 /media/jellyfin

          # Set default ACLs for future contents
          ${pkgs.acl}/bin/setfacl -d -m u::rwx,g::rwx,o::r-x /media/jellyfin
          ${pkgs.acl}/bin/setfacl -d -m mask::rwx /media/jellyfin
        '';
      };
    };
}
