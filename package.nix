{ stdenv, ... }:
stdenv.mkDerivation (finalAttrs: {
  pname = "saber-cursor";
  version = "1.0";
  src = ./src;
  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/share/icons/saber-cursor
    cp -r $src/* $out/share/icons/saber-cursor/
  '';
})
