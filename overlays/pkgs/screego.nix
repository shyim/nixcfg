{ stdenv, lib, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "screego";
  version = "1.6.2";

  src = fetchurl {
    url =
      "https://github.com/screego/server/releases/download/v1.6.2/screego_1.6.2_linux_amd64.tar.gz";
    sha256 = "sha256-bKAbdDoxEVi+uvGRYDfyKHg4FT6hozNoBkjiJFbUc1Y=";
  };

  nativeBuildInputs = [ makeWrapper ];
  dontBuild = true;
  setSourceRoot = "sourceRoot=`pwd`";

  installPhase = ''
    mkdir -p $out/bin
    cp screego $out/bin/
  '';

  meta = {
    homepage = "https://github.com/screego/server";
    description = "screen sharing for developers";
    maintainers = with lib.maintainers; [ shyim ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; unix;
  };
}