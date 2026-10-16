{ self, inputs, ... }: {
  flake.modules.nixos.home-manager =
    { lib, config, ... }:
    let
      cfg = config.rsnxmcst.home-manager;
    in
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      options.rsnxmcst.home-manager = {
        enable = inputs.self.lib.enableOpt;
      };

      config = lib.mkIf cfg.enable {
        home-manager = {
          verbose = true;
          useUserPackages = true;
          useGlobalPkgs = true;
          backupFileExtension = "backup";
          overwriteBackup = true;
          sharedModules = builtins.attrValues self.modules.homeManager;
        };
      };
    };
}
