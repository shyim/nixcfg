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

  configureIde = ide:
    ide.overrideAttrs (oldAttrs: {
      postPatch = ''
        rm -rf *.app/Contents/plugins/ml-llm/
        rm -rf *.app/Contents/plugins/color-scheme-*
        rm -rf *.app/Contents/plugins/phpspec/
        rm -rf *.app/Contents/plugins/codeception/
        rm -rf *.app/Contents/plugins/behat/
        rm -rf *.app/Contents/plugins/blade/
        rm -rf *.app/Contents/plugins/tailwindcss/
        rm -rf *.app/Contents/plugins/less/
        rm -rf *.app/Contents/plugins/drupal/
        rm -rf *.app/Contents/plugins/phpt/
        rm -rf *.app/Contents/plugins/gnuGetText/
        rm -rf *.app/Contents/plugins/keymap-*
        rm -rf *.app/Contents/plugins/nextjs/
        rm -rf *.app/Contents/plugins/javascript-cucumber/
        rm -rf *.app/Contents/plugins/angularJS/
        rm -rf *.app/Contents/plugins/vagrant/
        rm -rf *.app/Contents/plugins/joomla/
        rm -rf *.app/Contents/plugins/wordPress/
        rm -rf *.app/Contents/plugins/apacheConfig/
        rm -rf *.app/Contents/plugins/karma/
        rm -rf *.app/Contents/plugins/nodeJS-remoteInterpreter/
        rm -rf *.app/Contents/plugins/phing/
        rm -rf *.app/Contents/plugins/space/
        rm -rf *.app/Contents/plugins/tasks/
        rm -rf *.app/Contents/plugins/tasks-timeTracking/
        rm -rf *.app/Contents/plugins/uml/
        rm -rf *.app/Contents/plugins/ini/
        rm -rf *.app/Contents/plugins/styled-components/
        rm -rf *.app/Contents/plugins/clouds-docker-gateway/
        rm -rf *.app/Contents/plugins/searchEverywhereMl/
        rm -rf *.app/Contents/plugins/jsonpath/
        rm -rf *.app/Contents/plugins/gherkin/
        rm -rf *.app/Contents/plugins/php-architecture/
        rm -rf *.app/Contents/plugins/php-docker/
        rm -rf *.app/Contents/plugins/php-remoteInterpreter/
        rm -rf *.app/Contents/plugins/hunspell/
        rm -rf *.app/Contents/plugins/pest/
        rm -rf *.app/Contents/plugins/vcs-hg/
        rm -rf *.app/Contents/plugins/vcs-svn/
        rm -rf *.app/Contents/plugins/vcs-perforce/
        rm -rf *.app/Contents/plugins/webp/
        rm -rf *.app/Contents/plugins/remote-dev-server/
        rm -rf *.app/Contents/plugins/remoteRun/
        rm -rf *.app/Contents/plugins/copyright/
        rm -rf *.app/Contents/plugins/fileWatcher/
        rm -rf *.app/Contents/plugins/qodana/
        rm -rf *.app/Contents/plugins/php-workshop/
        rm -rf *.app/Contents/plugins/textmate/
        rm -rf *.app/Contents/plugins/performanceTesting*/
        rm -rf *.app/Contents/plugins/dynamicPluginsTests-performanceTesting/
        rm -rf *.app/Contents/plugins/gateway-plugin/
        rm -rf *.app/Contents/plugins/gateway-terminal/
        rm -rf *.app/Contents/plugins/cwm-plugin/
        rm -rf *.app/Contents/plugins/reStructuredText/
        rm -rf *.app/Contents/plugins/swagger/
        rm -rf *.app/Contents/plugins/xpath/
        rm -rf *.app/Contents/plugins/completionMlRanking/
        rm -rf *.app/Contents/plugins/completionMlRankingModels/
        rm -rf *.app/Contents/plugins/statsCollector/
        rm -rf *.app/Contents/plugins/featuresTrainer/
      '';
    });

  jetbrains = flake.inputs.jetbrains.packages.${pkgs.system}.jetbrains;
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
    gh
    htop
    jq
    nixSha
    ripgrep
    nodejs_20
    shopware-cli
    sops
    tmux
    zstd
		kubectl

    slack
    zoom-us
    vscode
		iterm2

    (configureIde jetbrains.phpstorm)
    (configureIde jetbrains.goland)
  ];

  programs.home-manager.enable = true;
}
