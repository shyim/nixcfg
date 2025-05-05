{ pkgs, ... }:
{
  sops.secrets.adguardLink = {
    restartUnits = [ "adguard-linkip.service" ];
  };

  systemd.services.adguard-linkip = {
    description = "AdGuard DNS LinkIP Update Service";

    # Define what the service should do
    script = ''
      ${pkgs.curl}/bin/curl -s "$ADGUARD_URL"
    '';

    # Service configuration
    serviceConfig = {
      EnvironmentFile = "/run/secrets/adguardLink";
      Type = "oneshot";
      User = "nobody"; # Run as unprivileged user for security
      DynamicUser = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      NoNewPrivileges = true;
    };
  };

  # Define the timer that triggers the service
  systemd.timers.adguard-linkip = {
    description = "AdGuard DNS LinkIP Update Timer";
    wantedBy = [ "timers.target" ];

    # Timer configuration
    timerConfig = {
      OnBootSec = "1min"; # Run shortly after boot
      OnUnitActiveSec = "10min"; # Run every 10 minutes thereafter
      AccuracySec = "1s"; # High timing accuracy
    };
  };
}
