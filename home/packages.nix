{ config
, pkgs
, lib
, devenv
, home-manager
, shopware-cli
, ...
}: 

let
  dockerUp = pkgs.writeShellScriptBin "docker-up" ''
    hcloud server create --image docker-ce --location hel1 --type cpx31 --name=docker-local --ssh-key 7588395
    docker context rm -f hetzner
    docker context create hetzner --docker "host=ssh://$(hcloud server describe docker-local -o json | jq .public_net.ipv4.ip -r)"
    docker context use hetzner
  '';
  dockerDown = pkgs.writeShellScriptBin "docker-down" ''
    hcloud server delete docker-local
    docker context rm -f hetzner
  '';
in {
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
    shopware-cli.packages.${system}.shopware-cli
    shopware-cli.packages.${system}.dart-sass-embedded
    fastly
    rclone
    age
    sops
    docker-client
    docker-compose
    dockerUp
    dockerDown
  ];

  programs.home-manager.enable = true;
}
