{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (git.override {
        osxkeychainSupport = false;
    })
  ];
}
