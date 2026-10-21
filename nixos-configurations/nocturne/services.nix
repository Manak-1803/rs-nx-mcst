{
  flake.modules.generic.nocturne = {
    rsnxmcst = {
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
