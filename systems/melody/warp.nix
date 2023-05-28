{ lib, pkgs, ... }: {
  environment.systemPackages = [ pkgs.cloudflare-warp ];
  systemd = {
    packages = [ pkgs.cloudflare-warp ];
    services.warp-svc = {
      after = [ "network-online.target" "systemd-resolved.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StateDirectory = "cloudflare-warp";
        User = "root";
        Umask = "0077";
        # Hardening
        LockPersonality = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
    };
  };
}
