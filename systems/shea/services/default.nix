{ config, pkgs, ... }:

{
  imports = [
   ./rclone.nix
   ./screego.nix
   ./switch.nix
   ./tailscale.nix
   ./thelounge.nix
   ./wakapi.nix
  ];
}
