{ config, pkgs, ... }:

{
  imports = [ ./opkssh.nix ];

  users.users.github = {
    isNormalUser = true;
    extraGroups = [ "docker" ];
  };

  services.openssh.settings.PasswordAuthentication = false;

  services.opkssh = {
    enable = true;

    providers = {
      google = {
        issuer = "https://accounts.google.com";
        clientId = "206584157355-7cbe4s640tvm7naoludob4ut1emii7sf.apps.googleusercontent.com";
        lifetime = "24h";
      };
      github = {
        issuer = "https://token.actions.githubusercontent.com";
        clientId = "github";
        lifetime = "oidc";
      };
    };

    authorizations = [
      {
        user = "github";
        principal = "s.sayakci@gmail.com";
        issuer = "https://accounts.google.com";
      }
      {
        user = "github";
        principal = "repo:FriendsOfShopware/shopmon:environment:staging";
        issuer = "https://token.actions.githubusercontent.com";
      }
      {
        user = "github";
        principal = "repo:FriendsOfShopware/shopmon:environment:production";
        issuer = "https://token.actions.githubusercontent.com";
      }
    ];
  };
}
