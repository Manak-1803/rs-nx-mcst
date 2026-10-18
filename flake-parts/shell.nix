{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nixd
          nixfmt

          age
          sops
          ssh-to-age
          age-plugin-tpm

          local.hash-ip
        ];
      };
    };
}
