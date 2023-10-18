{ pkgs, ... }: {
  home.file.".ssh/config.d/umbreon".text = ''
    Host umbreon.shy.ovh
        ProxyCommand ${pkgs.cloudflared}/bin/cloudflared access ssh --hostname %h
        User shyim
  '';

  home.file.".ssh/config.d/gitlab".text = ''
    Host gitlab.shopware.com
        IdentityFile ${pkgs.writeText "gitlab-public.key" (builtins.readFile ./keys/work.pub)}
        IdentitiesOnly yes
  '';

  home.file.".ssh/config.d/global".text = ''
    Host *
        ServerAliveInterval 60
        ControlMaster auto
        ControlPath /tmp/ssh-%r@%h:%p
  '';

  home.file.".ssh/config.d/gitpod".text = ''
    Host *.gitpod.io
        ForwardAgent yes
  '';
}
