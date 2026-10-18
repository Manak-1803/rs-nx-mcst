{ self, ... }: {
  flake.nixosConfigurations = self.lib.mkNixOS "terra";
}
