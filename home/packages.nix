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
    dockerDown
    dockerUp
    fd
    flake.inputs.devenv.packages.${system}.devenv
    flake.packages.${system}.ecsexec
    flake.packages.${system}.bun
    flake.inputs.froshpkgs.packages.${system}.shopware-cli
    gh
    htop
    jq
    nixSha
    ripgrep
    nodejs_21
    corepack_21
    sops
    tmux
    zstd
    kubectl
    go_1_22
    deno

    rustup

    (pkgs.writeShellScriptBin "kill-devenv" ''
      MYID=$$
      kill $(ps -ax | grep /nix/store | grep -v slack | grep -v vscode | grep -v zoom | grep -v iterm2 | grep -v $MYID | awk '{print $1}')
    '')
  ];

  programs.home-manager.enable = true;
}
