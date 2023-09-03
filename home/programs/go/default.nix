{ pkgs, flake, ... }: {
  programs.go = {
    enable = true;
    package = pkgs.go_1_21;
  };
}
