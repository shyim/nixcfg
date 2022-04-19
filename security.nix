{ config, pkgs, ... }:

{
    networking.firewall.allowedTCPPorts = [ 22 80 443 ];

    users.users.root.openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDPt71wkPbf84/vKgAl++Tz5BcLvZf/mcdxyzBc1KUQVsRxpNNMaGnQEgEV2cZIEJQiliDpkhdWBo5/pnlbKwPS3pW5X6IigeFON9mXdBod+xz8pGw/3mhqc5HLLfDLSKQ+oxedYHRJVXvJQrGuLI1AKbpX0ZhjMQQ9mwOpeVCwfhI9fyuUx+e9XFP83m/32qYZVBY3CkHDBh+HU8kCLnddQ/GIP+y2J5cLvf7+aAQpEx0W7mJjEY8nFMqtkBiS6WJMj/3bC8HjlC3muYz0VQAC+EZ/RHnp6Sn01rDD07yLzsF2lvysK1xSXM9t3s4nn2Zvi7gohj3j8cjWKclidfENXwBrdiv0EYuAb1Mbi7Mg0WDbdcZTMSvCEoUcBG56RahefNoIcO8MZeMDmKM3LYMYWQFkFpeFNt2i7cuNHkPyStPkgxFemCGq2fufeI7vSz7/q/sJYOg028Wbu41hGmXS58qNepeciX7x+yznsvjUtqSYM/5Y3bvCZCZA808aSuIp9RE63L2v/A5rwHkRpvFrbwmk2yXDfXkkSB7/Q51OOzpSMqqyimO8hVlMxSSUIdos8o9nweQJC70zMdX+BVLr2N7Hu4X8tfY4Bp0FgwwD6Uvog+S4quCMEi8mCWxeGOBbvc/Z6vlFC9NQ7q3TGEQlA67/jV3/QOcNyex5M5u0Gw=="
    ];
}