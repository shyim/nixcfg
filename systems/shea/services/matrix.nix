{ pkgs, lib, config, ... }:
let
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
  clientConfig."m.homeserver".base_url = "https://synapse.shyim.de";
  clientConfig."m.homeserver".server_name = "shyim.de";
  serverConfig."m.server" = "synapse.shyim.de:443";
  mkWellKnown = data: ''
    add_header Content-Type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in
{
  sops.secrets.synapse_config = {
    owner = "matrix-synapse";
    restartUnits = [ "matrix-synapse.service" ];
  };

  sops.secrets.mautrix_telegram = {
    restartUnits = [ "mautrix-telegram.service" ];
  };

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_15;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.nginx = {
    virtualHosts = {
      # If the A and AAAA DNS records on example.org do not point on the same host as the
      # records for myhostname.example.org, you can easily move the /.well-known
      # virtualHost section of the code to the host that is serving example.org, while
      # the rest stays on myhostname.example.org with no other changes required.
      # This pattern also allows to seamlessly move the homeserver from
      # myhostname.example.org to myotherhost.example.org by only changing the
      # /.well-known redirection target.
      "shyim.de" = {
        enableACME = true;
        forceSSL = true;
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "synapse.shyim.de" = {
        enableACME = true;
        forceSSL = true;
        locations."/".extraConfig = ''
          return 404;
        '';
        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
      };
      "element.shyim.de" = {
        enableACME = true;
        forceSSL = true;

        root = pkgs.element-web.override {
          conf = {
            default_server_config = clientConfig; # see `clientConfig` from the snippet above.
          };
        };
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    extraConfigFiles = [
      config.sops.secrets.synapse_config.path
    ];
    settings.server_name = config.networking.domain;
    settings.listeners = [
      {
        port = 8008;
        bind_addresses = [ "::1" ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = true;
        }];
      }
    ];
    settings.app_service_config_files = [
      "/var/lib/mautrix-whatsapp/whatsapp-registration.yaml"
      "/var/lib/matrix-synapse/telegram-registration.yaml"
      "/var/lib/mautrix-slack/slack-registration.yaml"
    ];
  };

  services.mautrix-whatsapp = {
    enable = true;
    settings = {
      homeserver.domain = "shyim.de";
      appservice.database.uri = "postgres://mautrix-whatsapp:mautrix@localhost/mautrix-whatsapp?sslmode=disable";

      bridge = {
        permissions = {
          "shyim.de" = "user";
          "@shyim:shyim.de" = "admin";
        };
        encryption = {
          allow = true;
          default = true;
        };
      };
    };
  };

  services.mautrix-telegram = {
    enable = true;
    environmentFile = config.sops.secrets.mautrix_telegram.path;
    settings = {
      homeserver = {
        domain = "shyim.de";
        address = "http://localhost:8008";
      };

      appservice = {
        provisioning.enabled = false;
        id = "telegram";
        database = "postgres://mautrix-telegram:mautrix@localhost/mautrix-telegram?sslmode=disable";
      };

      bridge = {
        permissions = {
          "shyim.de" = "user";
          "@shyim:shyim.de" = "admin";
        };
      };

      telegram = {
        connection.use_ipv6 = true;
      };
    };
  };

  systemd.services.mautrix-telegram.path = with pkgs; [
    lottieconverter
    ffmpeg
  ];

  services.mautrix-slack = {
    enable = true;

    settings = {
      homeserver = {
        domain = "shyim.de";
        address = "http://localhost:8008";
      };

      appservice.database.uri = "postgres://mautrix-slack:mautrix@localhost/mautrix-slack?sslmode=disable";

      bridge = {
        permissions = {
          "shyim.de" = "user";
          "@shyim:shyim.de" = "admin";
        };
      };
    };
  };
}
