{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "wakapi";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    rev = version;
    sha256 = "sha256-yMxcePwBUteqrdfvDjZSRInOXMFmwaFoVBihcMQFTME=";
  };

  excludedPackages = [ "scripts" ];

  CGO_CFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-return-local-addr" ];

  vendorSha256 = "sha256-sfx8qlmJrS0hkD6DSvKqfnBDbxj8eNA3hnprSwA2fSI=";

  meta = with lib; {
    homepage = "https://wakapi.dev";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3;
    maintainers = with maintainers; [ shyim ];
  };
}
