{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "wakapi";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "muety";
    repo = "wakapi";
    rev = version;
    sha256 = "sha256-uTDvipz08hrdFB/gAoxVp4Eesh57HOFUG4AD/5T33H8=";
  };

  excludedPackages = [ "scripts" ];

  CGO_CFLAGS = lib.optionals stdenv.cc.isGNU [ "-Wno-return-local-addr" ];

  vendorSha256 = "sha256-SqkE4vTT+QoLhKrQcGa2L5WmD+fCX7vli4FjgwLnqjg=";

  meta = with lib; {
    homepage = "https://wakapi.dev";
    description = "A minimalist, self-hosted WakaTime-compatible backend for coding statistics";
    license = licenses.gpl3;
    maintainers = with maintainers; [ shyim ];
  };
}
