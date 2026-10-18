{
  pkgs ? import <nixpkgs> { },
}:
pkgs.stdenv.mkDerivation {
  name = "hash-ip";

  src = ./.;
  buildInputs = [ pkgs.zlib ];

  buildPhase = ''
    $CC -O2 main.c -lz -o hash-ip
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp hash-ip $out/bin/
  '';
}
