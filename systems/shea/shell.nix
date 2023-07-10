{ config
, pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    htop
    neovim
    git
    psmisc # killall
    unzip
    tmux
  ];

  users.defaultUserShell = pkgs.fish;

  environment = {
    variables = {
      EDITOR = "nvim";
    };

    shellAliases = {
      nano = "nvim";
      vi = "nvim";
      vim = "nvim";
    };
  };

  programs.fish = {
    enable = true;
  };
}
