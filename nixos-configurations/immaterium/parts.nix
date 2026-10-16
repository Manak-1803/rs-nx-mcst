{ self, ... }: {
  flake.nixosConfigurations = self.lib.mkNixOS "immaterium";
}
