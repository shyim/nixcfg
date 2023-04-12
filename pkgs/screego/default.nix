{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, fetchYarnDeps
, fixup_yarn_lock
, nodejs
, fetchurl
, yarn
,
}:
buildGoModule rec {
  name = "screego";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "screego";
    repo = "server";
    rev = "v${version}";
    hash = "sha256-n17LFEzaqWQL2A4VUmiZFbuece2yl0/GirvXLvCr++w=";
  };

  patches = [
    ./force-turn.patch
  ];

  CGO_ENABLED = 0;
  tags = [ "netgo" "osusergo" ];
  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commitHash=00"
    "-X main.mode=prod"
  ];

  vendorHash = "sha256-KWAeoL3qvTxenhs0XtEHY1mpPzSiQMniqPnRLELwLKg=";

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/ui/yarn.lock";
    hash = "sha256-uUIHuiZeyjkOoYLiHa4KlkCZ5OPxFajiA72arueWmKY=";
  };

  preBuild = ''
    export HOME=$TEMPDIR
    cd ui

    yarn config --offline set yarn-offline-mirror ${offlineCache}
    fixup_yarn_lock yarn.lock
    yarn install --offline
    NODE_ENV=production node node_modules/.bin/react-scripts --max-old-space-size=3000 build

    cd ..
  '';

  postInstall = ''
    mv $out/bin/server $out/bin/screego
  '';

  nativeBuildInputs = [
    fixup_yarn_lock
    nodejs
    yarn
  ];

  meta = {
    homepage = "https://github.com/screego/server";
    description = "screen sharing for developers";
    maintainers = with lib.maintainers; [ shyim ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; unix;
  };
}
