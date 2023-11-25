{ lib, pkgs, config, ... }: {
  config = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
    home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
    systemd.user.sessionVariables.SSH_AUTH_SOCK = "${config.home.sessionVariables.SSH_AUTH_SOCK}";
  };
}
