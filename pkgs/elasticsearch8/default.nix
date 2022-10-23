{ lib
, stdenv
, fetchurl
, makeWrapper
, jre_headless
, util-linux
, gnugrep
, coreutils
, autoPatchelfHook
, zlib
}:

with lib;
let
  info = splitString "-" stdenv.hostPlatform.system;
  arch = elemAt info 0;
  plat = elemAt info 1;
  shas =
    {
      x86_64-linux   = "1s16l95wc589cr69pfbgmkn9rkvxn6sd6jlbiqpm6p6iyxiaxd61";
      x86_64-darwin  = "05h7pvq4pb816wgcymnfklp3w6sv54x6138v2infw5219dnk8pf1";
      aarch64-linux  = "0q4xnjzhlx1b2lkikca88qh9glfxaifsm419k2bxxlrfrx31zlk1";
      aarch64-darwin = "sha256-fMoizHv4n2FKTWO/716ccpTsDLIFeqzJoiUkYETt8/g=";
    };
in
stdenv.mkDerivation rec {
  pname = "elasticsearch";
  version = "8.2.0";

  src = fetchurl {
    url = "https://artifacts.elastic.co/downloads/elasticsearch/${pname}-${version}-${plat}-${arch}.tar.gz";
    sha256 = shas.${stdenv.hostPlatform.system} or (throw "Unknown architecture");
  };

  patches = [ ./es-home-6.x.patch ];

  postPatch = ''
    substituteInPlace bin/elasticsearch-env --replace \
      "ES_CLASSPATH=\"\$ES_HOME/lib/*\"" \
      "ES_CLASSPATH=\"$out/lib/*\""
    substituteInPlace bin/elasticsearch-cli --replace \
      "ES_CLASSPATH=\"\$ES_CLASSPATH:\$ES_HOME/\$additional_classpath_directory/*\"" \
      "ES_CLASSPATH=\"\$ES_CLASSPATH:$out/\$additional_classpath_directory/*\""
  '';

  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optional (!stdenv.hostPlatform.isDarwin) autoPatchelfHook;

  buildInputs = [ jre_headless util-linux zlib ];

  runtimeDependencies = [ zlib ];

  installPhase = ''
    mkdir -p $out
    cp -R bin config lib modules plugins $out
    chmod +x $out/bin/*
    substituteInPlace $out/bin/elasticsearch \
      --replace 'bin/elasticsearch-keystore' "$out/bin/elasticsearch-keystore" \
      --replace 'bin/elasticsearch-cli' "$out/bin/elasticsearch-cli"
    substituteInPlace $out/bin/elasticsearch-cli \
      --replace 'source "$ES_HOME"/bin' "source $out/bin"
    wrapProgram $out/bin/elasticsearch \
      --prefix PATH : "${makeBinPath [ util-linux coreutils gnugrep ]}" \
      --set ES_JAVA_HOME "${jre_headless}"
    wrapProgram $out/bin/elasticsearch-plugin --set ES_JAVA_HOME "${jre_headless}"
  '';

  passthru = { enableUnfree = true; };

  meta = {
    description = "Open Source, Distributed, RESTful Search Engine";
    license = licenses.elastic;
    platforms = platforms.unix;
    maintainers = with maintainers; [ apeschar basvandijk ];
  };
}