{
  flake.modules.generic.terra = {
    rsnxmcst = {
      core.enable = true;

      cloudflare-warp.enable = true;
      cosmic.enable = true;
      impermanence.enable = true;
      pangolin.enable = true;
      steam.enable = true;
      systemd-boot.enable = true;
      virt-manager.enable = true;

      user-cain.enable = true;

      nh.flakePath = "/home/cain/Projects/rs@nx@mcst";
    };

    nixpkgs.config.rocmSupport = true;
    networking.hostName = "terra";
    users.mutableUsers = false;

    nixpkgs.hostPlatform = "x86_64-linux";
    system.stateVersion = "26.11";
  };
}
