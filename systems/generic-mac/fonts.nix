{ pkgs, ... }: {
  fonts = {
    packages = [
      pkgs.jetbrains-mono
      pkgs.monaspace
      pkgs.inter
      pkgs.fira-code-nerdfont
    ];
  };
}
