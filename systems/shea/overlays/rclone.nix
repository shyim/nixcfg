final: prev: {
  rclone = prev.rclone.overrideAttrs (oldAttrs: {
    patches = [
      ./rclone-systemd.patch
    ];
  });
}
