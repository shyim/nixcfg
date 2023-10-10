{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nodejs_20
    git
    gzip
    kitty
  ];
}
