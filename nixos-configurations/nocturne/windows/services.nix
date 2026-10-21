{
  flake.modules.generic.nocturne =
    { lib, ... }:
    {
      specialisation.windows.configuration = {
        rsnxmcst = {
          jellyfin.enableNvidia = lib.mkForce false;
        };
      };
    };
}
