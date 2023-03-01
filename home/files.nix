{ config
, pkgs
, lib
, devenv
, home-manager
, ...
}: {
  home.file.".wakatime.cfg".text = ''[settings]

api_key = e2eaf7b6-b09d-4028-b0d7-9805f27ef2e4
api_url = https://time.fos.gg/api
'';

  home.file.".ssh/config".text = ''
    Host *.gitpod.io
      ForwardAgent yes

    Host *
      ServerAliveInterval 60
  '';

  home.file.".gnomerc".text = ''
    export SSH_AUTH_SOCK=~/.1password/agent.sock
  '';
  home.file.".npmrc".text = ''
    audit=false
    update-notifier=false
    prefix=${config.home.homeDirectory}/.npm-packages
  '';
}
