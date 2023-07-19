{ flake
, pkgs
, lib
, ...
}: {
  nix.distributedBuilds = lib.mkForce false;
  nix.buildMachines = lib.mkForce [ ];

  nixpkgs.config.permittedInsecurePackages = [
    "nodejs-16.20.1"
  ];

  environment.systemPackages = with pkgs; [
    flake.inputs.devenv.packages.${system}.devenv
    cachix
    htop
    github-runner
    tmux
  ];

  users.users.github-runner =
    {
      name = "github-runner";
      uid = 532;
      home = "/var/lib/github-runner";
      shell = "/bin/bash";
      description = "GitHub agent user";
    };
  users.groups.github-runner =
    {
      name = "github-runner";
      gid = 532;
      description = "GitHub agent user group";
    };

  #   launchd.daemons.gitlab-runner = {
  #     environment = {
  #       HOME = "${config.users.users.gitlab-runner.home}";
  #       NIX_SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
  #     } // (if config.nix.useDaemon then { NIX_REMOTE = "daemon"; } else { });
  #     path = with pkgs; [
  #       bash
  #       gawk
  #       jq
  #       moreutils
  #       remarshal
  #       github-runner
  #       coreutils
  #       gnugrep
  #       gnused
  #     ];

  #     script = ''
  #         STATE_DIRECTORY="$1"
  #         WORK_DIRECTORY="$2"
  #         LOGS_DIRECTORY="$3"
  #     '';

  #     serviceConfig = {
  #       ProcessType = "Interactive";
  #       ThrottleInterval = 30;

  #       # StandardOutPath = "/var/lib/gitlab-runner/out.log";
  #       # StandardErrorPath = "/var/lib/gitlab-runner/err.log";
  #       # The combination of KeepAlive.NetworkState and WatchPaths
  #       # will ensure that buildkite-agent is started on boot, but
  #       # after networking is available (so the hostname is
  #       # correct).
  #       RunAtLoad = true;
  #       #   KeepAlive.NetworkState = true;
  #       WatchPaths = [
  #         "/etc/resolv.conf"
  #         "/Library/Preferences/SystemConfiguration/NetworkInterfaces.plist"
  #       ];

  #       GroupName = "github-runner";
  #       UserName = "github-runner";
  #       WorkingDirectory = config.users.users.github-runner.home;
  #     };
  #   };
}
