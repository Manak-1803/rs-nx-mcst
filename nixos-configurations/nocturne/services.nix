{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
      peanut.enable = true;
      postgresql.enable = true;

      jellyfin = {
        enable = true;
        enableNvidia = true;
      };

      minecraft-server = {
        crator = true;
      };
    };
  };
}
