{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "wakapi";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    rev = version;
    sha256 = "sha256-1EMSrHx6Tx58voz5veyNZg1gnubuGyg2K4dg2QdzmMw=";
  };

  excludedPackages = [ "scripts" ];

  CGO_CFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-return-local-addr" ];

  vendorSha256 = "sha256-0wHXULDKyXYBTGxfSQXT/5NidPtSnx7ujb8vyczmE38=";

  meta = with lib; {
    homepage = "https://wakapi.dev";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3;
    maintainers = with maintainers; [ shyim ];
  };
}
