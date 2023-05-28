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

    Host shyim-mac
      HostName 100.71.118.111
      User shyim
      ForwardAgent yes
  '';

  home.file.".gnomerc".text = ''
    export SSH_AUTH_SOCK=~/.1password/agent.sock
  '';
  home.file.".npmrc".text = ''
    audit=false
    update-notifier=false
    prefix=${config.home.homeDirectory}/.npm-packages
  '';

  home.file.".config/pipewire/pipewire.conf.d/99-input-denoising.conf".text = lib.mkIf (pkgs.stdenv.isLinux) ''
    context.modules = [
    {   name = libpipewire-module-filter-chain
        args = {
            node.description =  "Noise Canceling source"
            media.name =  "Noise Canceling source"
            filter.graph = {
                nodes = [
                    {
                        type = ladspa
                        name = rnnoise
                        plugin = ${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so
                        label = noise_suppressor_mono
                        control = {
                            "VAD Threshold (%)" = 50.0
                            "VAD Grace Period (ms)" = 200
                            "Retroactive VAD Grace (ms)" = 0
                        }
                    }
                ]
            }
            capture.props = {
                node.name =  "capture.rnnoise_source"
                node.passive = true
                audio.rate = 48000
            }
            playback.props = {
                node.name =  "rnnoise_source"
                media.class = Audio/Source
                audio.rate = 48000
            }
        }
    }
    ]
  '';
}
