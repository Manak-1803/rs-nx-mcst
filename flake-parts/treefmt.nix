{ inputs, ... }: {
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem.treefmt = {
    programs = {
      nixfmt.enable = true;
      nixf-diagnose.enable = true;
      statix.enable = true;

      clang-format.enable = true;
      xmllint.enable = true;
    };
  };
}
