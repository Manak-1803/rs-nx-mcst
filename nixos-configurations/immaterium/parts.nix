{ self, ... }: {
  flake = {
    nixosConfigurations = self.lib.mkNixOS "immaterium";
    isoImage = self.nixosConfigurations.immaterium.config.system.build.isoImage;
  };
}
