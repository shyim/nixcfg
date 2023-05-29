{ lib
, yuzu-early-access
}:

yuzu-early-access.overrideAttrs (oldAttrs: {
  patches = [
    ./0001-bypass-extra-deps.patch
  ];
  cmakeFlags = [
    "-DYUZU_USE_BUNDLED_FFMPEG=ON"
    "-DYUZU_TESTS=OFF"
    "-DENABLE_LIBUSB=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DENABLE_SDL2=OFF"
    "-DENABLE_QT=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF"
    "-DUSE_DISCORD_PRESENCE=OFF"
    "-DYUZU_CHECK_SUBMODULES=OFF"
  ];
  meta.platforms = [ "x86_64-linux" "aarch64-linux" ];
})
