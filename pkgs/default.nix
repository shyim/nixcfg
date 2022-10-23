self: super: {
  awsume = super.callPackage ./awsume {};
  elasticsearch8 = super.callPackage ./elasticsearch8 {};
  openjdk = super.callPackage ./openjdk {};
  opensearch = super.callPackage ./opensearch {};
  php82 = super.pkgs.callPackage ./php82 {};
  screego = super.pkgs.callPackage ./screego {};
}
