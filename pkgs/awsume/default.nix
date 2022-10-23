{ lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "awsume";
  version = "4.5.3";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-6UzEwdDzzA24JwVy4ogMBkHOFM8iY1W/QkQLcmv0U+8=";
  };
  preConfigure = ''
    substituteInPlace setup.py \
      --replace "'install': CustomInstall," ""
  '';

  doCheck = false;
  propagatedBuildInputs = with python3.pkgs; [ psutil colorama pluggy pyyaml boto3 ];
}