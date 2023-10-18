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
    home.sessionVariables.GDK_DPI_SCALE = "1.25";
    home.sessionVariables.GDK_SCALE = "1.2";
    home.sessionVariables.GTK_SCALE = "1.25";
    home.sessionVariables.QT_SCALE_FACTOR = "1.25";

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

    home.packages = [
      (pkgs.writeShellScriptBin "xdg-open" ''
        exec ${pkgs.wsl-open}/bin/wsl-open "$@"
      '')
    ];

    programs.fish.loginShellInit = ''
      fish_add_path /home/shyim/.nix-profile/bin
      fish_add_path /nix/var/nix/profiles/default/bin
      alias code="/mnt/c/Program\ Files/Microsoft\ VS\ Code\ Insiders/Code\ -\ Insiders.exe"
    '';
  };
}
