{
  flake.modules.generic.nocturne = { lib, ... }: {
    specialisation.server.configuration = {
      rsnxmcst = {
        nut.enable = true;
        nut.server.enable = true;

        cloudflare-warp.enable = lib.mkForce false;
        cosmic.enable = lib.mkForce false;
        steam.enable = lib.mkForce false;
        virt-manager.enable = lib.mkForce false;

        audio.enable = lib.mkForce false;
        bluetooth.enable = lib.mkForce false;
      };

      home-manager.users.cain = {
        rsnxmcst = {
          core.graphical = lib.mkForce false;
        };
      };

      services.xserver.enable = lib.mkForce false;
    };
  };
}
