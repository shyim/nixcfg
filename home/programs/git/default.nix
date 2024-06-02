{ config
, pkgs
, lib
, ...
}: {
  imports = [
    ./macos.nix
  ];

  programs.lazygit.enable = true;

  home.packages = [ pkgs.gitsign ];

  systemd.user.services.gitsign-credential-cache = {
    Unit = {
      Description = "Gitsign Credential Cache";
    };
    Service = {
      ExecStart = "${pkgs.writeShellScript "start-credetial-cache" ''
        #!${pkgs.stdenv.shell}
        exec ${pkgs.gitsign}/bin/gitsign-credential-cache
      ''}";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.sessionVariables.GITSIGN_CREDENTIAL_CACHE = "${config.home.homeDirectory}/${if pkgs.stdenv.hostPlatform.isDarwin then
    "Library/Caches/sigstore/gitsign/cache.sock"
    else
    ".cache/sigstore/gitsign/cache.sock"}";
  systemd.user.sessionVariables.GITSIGN_CREDENTIAL_CACHE = config.home.sessionVariables.GITSIGN_CREDENTIAL_CACHE;

  programs.git = {
    enable = true;

    delta.enable = true;
    lfs.enable = true;

    userEmail = "s.sayakci@gmail.com";
    userName = "Soner Sayakci";

    extraConfig = {
      commit.gpgsign = true;
      push.default = "current";
      fetch.prune = true;
      pull.rebase = true;
      rebase.autoStash = true;
      init.defaultBranch = "main";
      gpg.format = "x509";
      gpg.x509.program = "gitsign";
      gitsign.connectorID = "https://github.com/login/oauth";
      tag.gpgsign = true;
      http.postBuffer = 157286400;
      credential.helper = [
        "cache"
        "oauth"
      ];

      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUY8rriTGw3ZcAtT6jJrsu5JAuUqi1WjFwOyWGoFZLA";

      url = {
        "https://github.com/" = {
          insteadOf = "git@github.com:";
        };
        "https://gitlab.shopware.com/" = {
          insteadOf = "git@gitlab.shopware.com:";
        };
      };

      credential."https://gitlab.shopware.com" = {
        oauthClientId = "27dbdada9445855de26ad7fd4f3f0e0eb30f31ee618cdbcc2987d3ba652e6f6d";
        oauthScopes = "read_repository write_repository";
        oauthAuthURL = "/oauth/authorize";
        oauthTokenURL = "/oauth/token";
      };
    };

    aliases = {
      a = "add";
      aa = "add --all";
      d = "diff";
      pl = "pull";
      pu = "push";
      puf = "push --force";
      s = "status";

      amend = "commit --amend --no-edit";

      # Reset commands
      r = "reset HEAD";
      r1 = "reset HEAD^";
      r2 = "reset HEAD^^";
      rhard = "reset --hard";
      rhard1 = "reset HEAD^ --hard";

      # Stash commands
      sd = "stash drop";
      spo = "stash pop";
      spu = "stash push";
    };

    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      "._*"

      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
    ];
  };
}
