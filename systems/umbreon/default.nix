{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./services.nix
    ./secrets
  ];

  nixpkgs.overlays = [
    # This System specific stuff
    (import ./overrides.nix)

    (import ../../pkgs)
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  environment.loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";
}
