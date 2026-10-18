{ inputs, withSystem, ... }: {
  imports = [ inputs.pkgs-by-name-for-flake-parts.flakeModule ];

  perSystem =
    { inputs', system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [ inputs.self.overlays.local-pacakges ];
      };

      pkgsDirectory = inputs.packages;

      packages = {
        inherit (inputs'.disko.packages) disko;
      };
    };

  flake = {
    overlays.local-pacakges =
      final: prev:
      withSystem prev.stdenv.hostPlatform.system (
        { config, ... }:
        {
          local = config.packages;
        }
      );
  };
}
