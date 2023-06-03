{ config
, pkgs
, lib
, ...
}: {
  programs.lazygit.enable = true;

  programs.git = {
    enable = true;

    delta.enable = true;

    userEmail = "s.sayakci@shopware.com";
    userName = "Soner Sayakci";

    extraConfig = {
      commit.gpgsign = true;
      push.default = "current";
      fetch.prune = true;
      pull.rebase = true;
      rebase.autoStash = true;
      init.defaultBranch = "main";
      gpg.format = "ssh";
      tag.gpgsign = true;
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
