{ flake
, pkgs
, lib
, ...
}: {
  imports = [
    ./packages.nix
    ./services.nix
    ./fonts.nix
  ];

  programs.bash.enable = true;
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    settings.substituters = [
      "https://shopware.cachix.org"
      "https://shyim.cachix.org"
      "https://devenv.cachix.org"
    ];
    settings.trusted-public-keys = [
      "shopware.cachix.org-1:IDifwLVQaaDU2qhlPkJsWJp/Pq0PfzHPIB90hBOhL3k="
      "shyim.cachix.org-1:ZazuDAWm/q5YbFVmuJCTYbnopdR1NqI2Hl8IgZ1jYIM="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    extraOptions = ''
      experimental-features = nix-command flakes auto-allocate-uids repl-flake
      auto-allocate-uids = true
      builders-use-substitutes = true
      builders = @/etc/nix/machines
      log-lines = 100
      nix-path = nixpkgs=${flake.inputs.nixpkgs}
      extra-platforms = x86_64-darwin aarch64-darwin
    '';
    settings.trusted-users = [ "root" "shyim" ];
  };

  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  documentation.enable = false;
  documentation.man.enable = false;
  security.pam.enableSudoTouchIdAuth = true;

  time.timeZone = "Europe/Berlin";

  system.defaults.finder.ShowPathbar = true;
  system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  system.defaults.NSGlobalDomain = {
    "com.apple.swipescrolldirection" = false;
    "AppleShowAllFiles" = true;
    "AppleShowAllExtensions" = true;
  };

  environment.loginShellInit = "fish_add_path --move --prepend --path $HOME/.nix-profile/bin /run/wrappers/bin /etc/profiles/per-user/$USER/bin /nix/var/nix/profiles/default/bin /run/current-system/sw/bin";

  mas.apps = [
    # iStat Menus
    "1319778037"
  ];

  system.activationScripts.postUserActivation.text = ''
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/ml-llm/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/color-scheme-*
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/phpspec/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/codeception/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/behat/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/blade/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/tailwindcss/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/less/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/drupal/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/phpt/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/gnuGetText/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/keymap-*
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/nextjs/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/javascript-cucumber/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/angularJS/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/vagrant/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/joomla/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/wordPress/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/apacheConfig/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/karma/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/nodeJS-remoteInterpreter/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/phing/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/space/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/tasks/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/tasks-timeTracking/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/uml/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/ini/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/styled-components/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/clouds-docker-gateway/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/clouds-docker-impl/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/searchEverywhereMl/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/jsonpath/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/gherkin/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/php-architecture/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/php-docker/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/php-remoteInterpreter/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/hunspell/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/pest/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/vcs-hg/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/vcs-svn/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/vcs-perforce/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/webp/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/remote-dev-server/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/remoteRun/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/copyright/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/fileWatcher/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/qodana/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/php-workshop/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/textmate/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/performanceTesting*/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/dynamicPluginsTests-performanceTesting/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/gateway-plugin/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/gateway-terminal/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/cwm-plugin/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/reStructuredText/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/swagger/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/xpath/
    rm -rf /Users/shyim/Applications/PhpStorm.app/Contents/plugins/completionMlRanking/
  '';
}
