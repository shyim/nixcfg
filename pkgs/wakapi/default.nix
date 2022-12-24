{ lib
, buildGoModule
, fetchFromGitHub
,
}:
buildGoModule {
  pname = "wakapi";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    rev = "2.5.4";
    sha256 = "sha256-IWTSxfpJ1zQImo6rxnSPgGte83VSRrF7Bkhv2r6KkRo=";
  };

  preBuild = ''
    substituteInPlace config/db.go \
    --replace '@tcp(%s:%d)' "@unix(%s)"

    substituteInPlace config/db.go \
    --replace 'config.Port,' ""
  '';

  doCheck = false;

  vendorSha256 = "sha256-heLJ6Yl+DPj74sDvHpDgtEf9Ogpj54Kpk2Z20z2/7qw=";

  meta = with lib; {
    homepage = "https://wakapi.dev";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3;
    maintainers = with maintainers; [ shyim ];
  };
}
