{ config, pkgs, ... }:

{
  services.docker-compose.qodana.config = {
    services.nginx = {
      image = "nginx:alpine";
      volumes = [
        "/home/qodana/web:/usr/share/nginx/html"
        "/home/qodana/nginx.conf:/etc/nginx/conf.d/default.conf"
      ];
      labels = [
        "traefik.enable=true"
        "traefik.http.routers.http-qodana.entrypoints=web"
        "traefik.http.routers.http-qodana.rule=Host(`qodana.fos.gg`)"
        "traefik.http.routers.http-qodana.middlewares=web-redirect@file"
        "traefik.http.routers.qodana.entrypoints=websecure"
        "traefik.http.routers.qodana.rule=Host(`qodana.fos.gg`)"
        "traefik.http.routers.qodana.middlewares=compress@file"
        "traefik.http.routers.qodana.tls.certresolver=cf"
        "traefik.http.routers.qodana.tls.domains[0].main=qodana.fos.gg"
      ];
    };
  };

  users.groups.qodana.gid = 590;
  users.users.qodana = {
    group = "qodana";
    home = "/home/qodana/";
    createHome = true;
    shell = pkgs.bash;
    isSystemUser = true;
    uid = 590;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDfpyPzgR2cacFdhWbo9gykgd6ExjbHngjCLfqZAyR0atErTnumhMoLUBIu0OKrir1mYqTQ0vyTFGeF0gDGWIiQOmHED49/R6KmFgrA4YI++gvTq/R+Y4Fcq9JPU08glgrkRxqNBqKJ07r1ewtfGARmsCYBnL4Szd37J5EoaeFw/FeQaQnJepXfGuzGja9HXOKQCgaWlmrC9LsNWrR7oSllt10RRqG5nt4Nh/wLZaOPzPiClVPKumb/3SFL7LKI0BLxQGCTx32UIFuD891jLe0P0i5X63v/P0iVPgHggeoeYyNcfFkEfJO73OywhnTUvM69wuU88BJfevs1KQXL83a6rFOJ2v8+Ic6iNu03fAD3hgwbwtwW2Hfn/FvdOvNT+3/kVRxJXg3ob7xNdUeDi5P2B8C3DcYJj0VrKhqJBl/8VuLKZ9WXn71UZiRj9Nuk/Fy3br+Hl4MJWJ0pjWlWpu/dtYJ8t+c02LkK1griAP/AOPG/sgrYigCYuzE3VQpwwt0="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPt71wkPbf84/vKgAl++Tz5BcLvZf/mcdxyzBc1KUQVsRxpNNMaGnQEgEV2cZIEJQiliDpkhdWBo5/pnlbKwPS3pW5X6IigeFON9mXdBod+xz8pGw/3mhqc5HLLfDLSKQ+oxedYHRJVXvJQrGuLI1AKbpX0ZhjMQQ9mwOpeVCwfhI9fyuUx+e9XFP83m/32qYZVBY3CkHDBh+HU8kCLnddQ/GIP+y2J5cLvf7+aAQpEx0W7mJjEY8nFMqtkBiS6WJMj/3bC8HjlC3muYz0VQAC+EZ/RHnp6Sn01rDD07yLzsF2lvysK1xSXM9t3s4nn2Zvi7gohj3j8cjWKclidfENXwBrdiv0EYuAb1Mbi7Mg0WDbdcZTMSvCEoUcBG56RahefNoIcO8MZeMDmKM3LYMYWQFkFpeFNt2i7cuNHkPyStPkgxFemCGq2fufeI7vSz7/q/sJYOg028Wbu41hGmXS58qNepeciX7x+yznsvjUtqSYM/5Y3bvCZCZA808aSuIp9RE63L2v/A5rwHkRpvFrbwmk2yXDfXkkSB7/Q51OOzpSMqqyimO8hVlMxSSUIdos8o9nweQJC70zMdX+BVLr2N7Hu4X8tfY4Bp0FgwwD6Uvog+S4quCMEi8mCWxeGOBbvc/Z6vlFC9NQ7q3TGEQlA67/jV3/QOcNyex5M5u0Gw=="
    ];
  };
}
