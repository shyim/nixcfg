{ lib
, stdenvNoCC
, fetchurl
, makeWrapper
, jre_headless
, util-linux
, gnugrep
, coreutils
, autoPatchelfHook
, zlib
}:

stdenvNoCC.mkDerivation rec {
  pname = "opensearch";
  version = "2.3.0";

  src = fetchurl {
    url = "https://artifacts.opensearch.org/releases/bundle/opensearch/2.3.0/opensearch-2.3.0-linux-x64.tar.gz";
    sha256 = "1jhhz6f58iz5l920avnp0aaai3lfqpqwymk447bjlbvd2arh0rb9";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre_headless util-linux ];
  patches = [ ./opensearch-home-fix.patch ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out

    substituteInPlace $out/bin/opensearch \
      --replace 'bin/opensearch-keystore' "$out/bin/opensearch-keystore"

    wrapProgram $out/bin/opensearch \
      --prefix PATH : "${lib.makeBinPath [ util-linux gnugrep coreutils ]}" \
      --set JAVA_HOME "${jre_headless}"

    wrapProgram $out/bin/opensearch-plugin --set JAVA_HOME "${jre_headless}"
  '';

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shyim ];
  };
}
