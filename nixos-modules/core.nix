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
