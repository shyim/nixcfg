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
  pname = "dynamodb";
  version = "2022-09-10";

  src = fetchurl {
    url = "https://s3.eu-central-1.amazonaws.com/dynamodb-local-frankfurt/dynamodb_local_2022-09-10.tar.gz";
    sha256 = "0jpxf8liv0b3dr9rsymc5h2zfb5h65prhs782yrp5ds7fz1hadsb";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre_headless ];

  installPhase = ''
    mkdir -p $out/bin

    cp -R DynamoDBLocal_lib DynamoDBLocal.jar $out

    tee -a $out/bin/dynamodb << END
    #!${stdenvNoCC.shell}
    exec ${jre_headless}/bin/java -Djava.library.path=$out/DynamoDBLocal_lib -jar $out/DynamoDBLocal.jar "\$@"
    END

    chmod +x $out/bin/dynamodb
  '';

  meta = {
    description = "Fast, flexible NoSQL database service for single-digit millisecond performance at any scale";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ shyim ];
  };
}
