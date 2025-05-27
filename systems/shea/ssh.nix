{ config, pkgs, ... }:

let
  opkssh = (pkgs.callPackage ./pkgs/opkssh.nix { });
in
{
  users.users.github = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };

  users.groups.opksshuser = { };
  users.users.opksshuser = {
    isSystemUser = true;
    description = "OpenID Connect SSH User";
    group = "opksshuser";
  };

  services.openssh = {
    authorizedKeysCommand = "/run/wrappers/bin/opkssh verify %u %k %t";
    authorizedKeysCommandUser = "opksshuser";

    settings = {
      "PasswordAuthentication" = false;
    };
  };

  security.wrappers."opkssh" = {
    source = "${opkssh}/bin/opkssh";
    owner = "root";
    group = "root";
  };

  environment.etc."opk/providers" = {
    mode = "0640";
    user = "opksshuser";
    group = "opksshuser";
    text = ''
      https://accounts.google.com 206584157355-7cbe4s640tvm7naoludob4ut1emii7sf.apps.googleusercontent.com 24h
      https://token.actions.githubusercontent.com github oidc
    '';
  };

  environment.etc."opk/auth_id" = {
    mode = "0640";
    user = "opksshuser";
    group = "opksshuser";
    text = ''
      github s.sayakci@gmail.com https://accounts.google.com
      github repo:FriendsOfShopware/shopmon:ref:refs/heads/main https://token.actions.githubusercontent.com
      github repo:shyim/opkssh-test:ref:refs/heads/main https://token.actions.githubusercontent.com
    '';
  };
}
