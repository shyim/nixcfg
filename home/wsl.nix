{ config
, pkgs
, lib
, devenv
, home-manager
, ...
}: {
  systemd.user.services.ssh-proxy = lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
    Unit = {
      Description = "WSL Proxy";
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "start-proxy" ''
        rm -f /tmp/.ssh-sock
        setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:/tmp/.ssh-sock,fork EXEC:"/mnt/c/Windows/system32/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork
      ''}";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
