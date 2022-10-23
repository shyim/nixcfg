{ lib
, stdenv
, fetchurl
, makeWrapper
, zlib
}:

stdenv.mkDerivation (rec {
  pname = "openjdk";
  version = "17.0.2";

  src = fetchurl {
    url = "https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_macos-aarch64_bin.tar.gz";
    sha256 = "1j17ijqvpw1zymah9i0c5sfn7slnfr1c958dz2rqndi64pkpsbb0";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    mv Contents $out
  '';

  meta = {
    description = "OpenJDK Development Kit";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shyim ];
  };
})