{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nodejs-16_x
    hcloud
    bash
  ];
}
