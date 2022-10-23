{ config, pkgs, ... }:

{
  networking = {
    hostName = "helia";
    domain = "shyim.de";
    interfaces.ens3.ipv6.addresses = [{
      address = "2a01:4f8:1c1e:cd09::";
      prefixLength = 64;
    }];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
  };
}
