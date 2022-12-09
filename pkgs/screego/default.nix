{ stdenv, lib, fetchurl, makeWrapper }:

let
  version = "1.8.0";
  sources = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/screego/server/releases/download/v${version}/screego_${version}_linux_amd64.tar.gz";
      sha256 = "1y2kjg8pkfvj28d9yh5bzf55r324p36ssydp44zzw5gda5zrmabc";
    };
    "aarch64-linux" = fetchurl {
      url = "https://github.com/screego/server/releases/download/v${version}/screego_${version}_linux_arm64.tar.gz";
      sha256 = "sha256-+EFezY6m0A9L+s+5dryXwN+BbjN0abhethMRG9jsLMo=";
    };
  };
in stdenv.mkDerivation rec {
  name = "screego";
  inherit version;

  src = sources.${stdenv.hostPlatform.system} or (throw "Unsupported platform for screego: ${stdenv.hostPlatform.system}");

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
