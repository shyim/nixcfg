{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nodejs-18_x
    hcloud
    bash
    git
  ];
}
