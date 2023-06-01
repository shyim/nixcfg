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
      init.defaultBranch = "main";
      gpg.format = "ssh";
      tag.gpgsign = true;

      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUY8rriTGw3ZcAtT6jJrsu5JAuUqi1WjFwOyWGoFZLA";

      url = {
        "https://github.com/" = {
          insteadOf = "git@github.com:";
        };
      };

      credential."https://github.com" = {
        oauthClientId = "b91952eb195b2b835775";
        oauthClientSecret = "fc42dad303fcafe86bb732e005edb20eb4ddea60";
        helper = [
          "cache"
          "oauth"
        ];
      };

      credential."https://gitlab.com" = {
        oauthClientId = "479c978e0e09e2fd3cb96cef0f2228d20dece607e79110af533300cf24bf5600";
        oauthClientSecret = "94699afe5471650667839e1e3c42080d0aeaa18ed34e6ce0f3a0a931ff47681b";
        helper = [
          "cache"
          "oauth"
        ];
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
