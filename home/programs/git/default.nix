{ ...
}: {
  programs.lazygit.enable = true;

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
      gpg.format = "ssh";
      tag.gpgsign = true;
      http.postBuffer = 157286400;
      credential.helper = [
        "cache --timeout 21600"
        "manager"
      ];

      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJUY8rriTGw3ZcAtT6jJrsu5JAuUqi1WjFwOyWGoFZLA";

      url = {
        "https://github.com/" = {
          insteadOf = "git@github.com:";
        };
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
