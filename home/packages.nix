{ config
, pkgs
, lib
, devenv
, home-manager
, ...
}:

let
  dockerUp = pkgs.writeShellScriptBin "docker-up" ''
    hcloud server create --image docker-ce --location fsn1 --type cpx31 --name=docker-local --ssh-key 7588395
    docker context rm -f hetzner
    SERVER_IP=$(hcloud server describe docker-local -o json | jq .public_net.ipv4.ip -r)
    docker context create hetzner --docker "host=ssh://root@$SERVER_IP"
    docker context use hetzner
    ssh-keygen -R "$SERVER_IP"
    ssh-keyscan "$SERVER_IP" >> ~/.ssh/known_hosts
  '';
  dockerDown = pkgs.writeShellScriptBin "docker-down" ''
    docker context rm -f hetzner
    hcloud server delete docker-local
  '';
in
{
  home.packages = with pkgs; [
    nixpkgs-fmt
    git
    htop
    jq
    tree
    tmux
    wget
    fd
    bash
    gh
    asciinema
    ripgrep
    bat
    devenv.packages.${system}.devenv
    shopware-cli
    dart-sass-embedded
    fastly
    rclone
    age
    sops
    docker-client
    docker-compose
    dockerUp
    dockerDown
    colima
    ncdu
    cosign
  ];

  programs.home-manager.enable = true;
}
