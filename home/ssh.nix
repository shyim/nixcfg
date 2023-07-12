{ lib, pkgs, ... }: {
  config = lib.mkIf (pkgs.stdenv.isLinux) {
    home.sessionVariables.SSH_AUTH_SOCK = ".1password/agent.sock";
    systemd.user.sessionVariables.SSH_AUTH_SOCK = ".1password/agent.sock";
  };
}
