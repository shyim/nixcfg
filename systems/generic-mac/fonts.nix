{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;

    fonts = [
      pkgs.jetbrains-mono
      pkgs.monaspace
      pkgs.inter
      pkgs.fira-code-nerdfont
    ];
  };
}
