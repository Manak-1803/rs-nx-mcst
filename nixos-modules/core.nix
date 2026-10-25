{ inputs, ... }: {
  flake.modules.nixos.core =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfg = config.rsnxmcst.core;
    in
    {
      options.rsnxmcst.core = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        sops.secrets."user-passwords/root".neededForUsers = true;

        services = {
          openssh.generateHostKeys = true;
          xserver.excludePackages = [ pkgs.xterm ];
        };

        rsnxmcst = {
          fwupd.enable = true;
          home-manager.enable = true;
          libvirtd.enable = true;
          locale.enable = true;
          network-manager.enable = true;
          nh.enable = true;
          nix.enable = true;
          nixpkgs.enable = true;
          podman.enable = true;
          qwerty.enable = true;
          secrets.enable = true;
          sudo.enable = true;
          tpm.enable = true;

          nix.substituters = {
            "https://cache.rsnxmcst.dedyn.io/main" = "main:oZ6ulr31W5NUttMRoIqUUWEQtU7grq1wOJCIpULS/Z4=";

            "https://nix-community.cachix.org" =
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
          };
        };

        boot.kernelPackages = pkgs.linuxPackages_latest;

        environment.systemPackages = with pkgs; [
          lsof
          psmisc
          usbutils
          pciutils
        ];

        users.users.root = {
          hashedPasswordFile = config.sops.secrets."user-passwords/root".path;
        };
      };
    };
}
