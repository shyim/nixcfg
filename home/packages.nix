{ config
, pkgs
, lib
, flake
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
  nixSha = pkgs.writeShellScriptBin "nix-sha" ''
    nix hash to-sri sha256:$(nix-prefetch-url $1)
  '';
in
{
  home.packages = with pkgs; [
    age
    asciinema
    bat
    trivy
    dockerDown
    dockerUp
    cloudflared
    fd
    flake.inputs.devenv.packages.${system}.devenv
    flake.packages.${system}.ecsexec
    flake.packages.${system}.bun
    gh
    github-copilot-cli
    htop
    jq
    ncdu
    nixSha
    nixpkgs-fmt
    ripgrep
    nodejs_20
    corepack_20
    shopware-cli
    sops
    tmux
    wget
    zstd
    opentofu

    php83
    php83Packages.composer

    kubernetes-helm
    kubectl
  ];

  programs.home-manager.enable = true;
}
