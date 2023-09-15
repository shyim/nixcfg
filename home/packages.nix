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
    bash
    bun
    bat
    cosign
    docker
    dockerDown
    dockerUp
    deno
    cloudflared
    fastly
    fd
    flake.inputs.devenv.packages.${system}.devenv
    flake.inputs.nixd.packages.${system}.nixd
    flake.packages.${system}.ecsexec
    gh
    git-credential-oauth
    github-copilot-cli
    htop
    jq
    ncdu
    nixSha
    nixpkgs-fmt
    rclone
    ripgrep
    nodejs_20
    (pkgs.runCommand "corepack-enable" { } ''
      mkdir -p $out/bin
      ${pkgs.nodejs_20}/bin/corepack enable --install-directory $out/bin
    '')
    shopware-cli
    sops
    tmux
    tree
    wget
    php82
    php82Packages.composer
  ];

  programs.home-manager.enable = true;
}
