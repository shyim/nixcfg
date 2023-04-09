{ config
, pkgs
, lib
, ...
}:
let
  socket = "${config.home.homeDirectory}/.1password/agent.sock";
in
{
  config = lib.mkIf (builtins.getEnv "WSLENV" != "") {
    systemd.user.services.ssh-proxy = {
      Unit = {
        Description = "WSL Proxy";
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "start-proxy" ''
          rm -f ${socket}
          mkdir -p $(dirname ${socket})
          setsid ${pkgs.socat}/bin/socat UNIX-LISTEN:${socket},fork EXEC:"/mnt/c/Windows/system32/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork
        ''}";
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    home.sessionVariables.SSH_AUTH_SOCK = socket;
    systemd.user.sessionVariables.SSH_AUTH_SOCK = socket;

    # IP is hopefully always same
    home.sessionVariables.DISPLAY = "172.23.0.1:0.0";
    systemd.user.sessionVariables.DISPLAY = "172.23.0.1:0.0";

    home.packages = [
      (pkgs.writeShellScriptBin "xdg-open" ''
        exec ${pkgs.wsl-open}/bin/wsl-open "$@"
      '')
    ];

    programs.fish.loginShellInit = ''
      fish_add_path /home/shyim/.nix-profile/bin
      fish_add_path /nix/var/nix/profiles/default/bin
    '';
  };
}
