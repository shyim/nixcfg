{ pkgs, flake, ... }:

{
  services.mediamtx = {
    enable = true;
    settings = {
      api = false;
      metrics = false;
      pprof = false;
      rtmp = false;
      rtsp = false;
      hls = false;
      srt = false;
      paths = {
        live = {
          source = "publisher";
        };
      };
    };
  };
}
