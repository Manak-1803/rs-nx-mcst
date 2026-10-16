{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    programs = {
      nixfmt.enable = true;
      nixf-diagnose.enable = true;
      statix.enable = true;
    };
  };
}
