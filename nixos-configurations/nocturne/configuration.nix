{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
      core.enable = true;

      cloudflare-warp.enable = true;
      containers.enable = true;
      cosmic.enable = true;
      impermanence.enable = true;
      newt.enable = true;
      sshd.enable = true;
      steam.enable = true;
      systemd-boot.enable = true;
      virt-manager.enable = true;

      user-cain.enable = true;

      containers.externalNAT = "wlan0";
      nh.flakePath = "/home/cain/Projects/rs@nx@mcst";

      nix.substituters = {
        "https://nix-community.cachix.org" =
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";

        "https://cache.nixos-cuda.org" =
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=";
      };
    };

    nixpkgs.config.nvidiaSupport = true;
    networking.hostName = "nocturne";
    users.mutableUsers = false;

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.11";
  };
}
