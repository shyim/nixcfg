{ lib
, stdenvNoCC
, fetchurl
}:
stdenvNoCC.mkDerivation rec {
  pname = "cloudreve";
  version = "3.8.0";

  setSourceRoot = "sourceRoot=$PWD";

  src = fetchurl {
    url = "https://github.com/cloudreve/Cloudreve/releases/download/3.8.0/cloudreve_3.8.0_linux_arm64.tar.gz";
    hash = "sha256-aO8gsJ0R/KU8WHvV+vpyNGeqLdl+sd3osjM4t0OgQQw=";
  };

  installPhase = ''
    mkdir -p $out/bin

    cp cloudreve $out/bin
    chmod +x $out/bin/cloudreve
  '';
}
