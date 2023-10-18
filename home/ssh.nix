{ lib, pkgs, config, ... }: {
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/${if pkgs.stdenv.hostPlatform.isDarwin then "Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" else ".1password/agent.sock"}";
  systemd.user.sessionVariables.SSH_AUTH_SOCK = "${config.home.sessionVariables.SSH_AUTH_SOCK}";
}
