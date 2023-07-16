{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, olm
}:
buildGoModule rec {
  pname = "mautrix-slack";
  version = "1.0.0";

  buildInputs = [ olm ];

  doCheck = false;

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "slack";
    rev = "9b2a53fd8c9d1b57936037f775c54955c993e5be";
    sha256 = "sha256-Ww4QDQL7A3gqBYQE1ZzwY1F8zU8dDHlmcgUa0ur3k4U=";
  };

  vendorSha256 = "sha256-yQe15hqzFVmNqWwMxJ3KpREa14ezaJI4jc6iBN8pRmE=";
}
