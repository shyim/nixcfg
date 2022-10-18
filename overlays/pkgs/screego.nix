{ stdenv, lib, fetchurl, makeWrapper }:

stdenv.mkDerivation rec {
  name = "screego";
  version = "1.7.4";

  src = fetchurl {
    url =
      "https://github.com/screego/server/releases/download/v1.7.4/screego_1.7.4_linux_amd64.tar.gz";
    sha256 = "1y2kjg8pkfvj28d9yh5bzf55r324p36ssydp44zzw5gda5zrmabc";
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
