{ pkgs , ... }: {
  environment.systemPackages = with pkgs; [
     vim
     ghostty.terminfo
     htop
  ];
}