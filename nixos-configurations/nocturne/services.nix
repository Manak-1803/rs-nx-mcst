{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
      attic-server.enable = true;
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
