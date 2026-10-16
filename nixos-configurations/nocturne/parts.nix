{ self, ... }: {
  flake.nixosConfigurations = self.lib.mkNixOS "nocturne";
}
