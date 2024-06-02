{ lib, pkgs, config, flake, ... }: {
  config = lib.mkIf (pkgs.stdenv.hostPlatform.isDarwin) {
    launchd.enable = true;
    launchd.agents.gitsign-credential-cache = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.gitsign}/bin/gitsign-credential-cache" ];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
