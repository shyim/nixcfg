{ config, pkgs, ... }:

{
  services.docker-compose.wireguard.config = {
    services.wireguard = {
      container_name = "wireguard";
      cap_add = [ "NET_ADMIN" "SYS_MODULE" ];
      sysctls = [
        "net.ipv4.conf.all.src_valid_mark=1"
        "net.ipv6.conf.all.disable_ipv6=0"
      ];
      image = "lscr.io/linuxserver/wireguard";
      volumes = [ "/srv/docker/wireguard/:/config" ];
    };
  };
}
