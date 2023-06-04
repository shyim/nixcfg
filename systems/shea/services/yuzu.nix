{ config
, pkgs
, flake
, ...
}: {
  sops.secrets = {
    yuzu_room = { };
  };

  systemd.services.yuzu-room = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      EnvironmentFile = config.sops.secrets.yuzu_room.path;
      ExecStart = "${flake.packages."aarch64-linux".yuzu-room}/bin/yuzu-room --room-name 'Shyim Room' --room-description 'MK8' --preferred-game 'Mario Kart 8 Deluxe' --preferred-game-id '0x0100EA80032EA000' --port 5000 --max_members 8 --enable-yuzu-mods --token $YUZU_ROOM_SECRET --web-api-url https://api.yuzu-emu.org";
      DynamicUser = true;
    };
  };
}
