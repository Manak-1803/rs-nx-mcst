{ inputs, ... }: {
  flake.modules.generic.immaterium = { pkgs, ... }: {
    imports = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ];

    nixpkgs.config = {
      allowUnfree = true;
    };

    services.openssh = {
      enable = true;
      openFirewall = true;

      settings = {
        LogLevel = "VERBOSE";
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;

        MaxAuthTries = 3;
        ClientAliveCountMax = 3;
        ClientAliveInterval = 300;
      };
    };

    nix = {
      settings = {
        experimental-features = [
          "flakes"
          "nix-command"
          "pipe-operators"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];

        fallback = true;
        min-free = 128 * 1024 * 1024;
        max-free = 1024 * 1024 * 1024;
        download-buffer-size = 1024 * 1024 * 1024;

        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos-cuda.org"
        ];

        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };
    };

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "immaterium";
    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.11";
  };
}
