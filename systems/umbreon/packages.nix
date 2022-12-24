{ pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    redis
    nodejs-16_x
    platformsh
    hcloud
    awscli2
    ssm-session-manager-plugin
    bash
    cloudflared
    go-jira
  ];
}
