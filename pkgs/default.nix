self: super: {
  awsume = super.callPackage ./awsume { };
  elasticsearch8 = super.callPackage ./elasticsearch8 { };
  openjdk = super.callPackage ./openjdk { };
  opensearch = super.callPackage ./opensearch { };
  screego = super.pkgs.callPackage ./screego { };
}
