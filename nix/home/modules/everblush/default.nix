{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  home.packages = with pkgs; [
    eww
    (writers.writeBashBin "herb-ws-switch" ./ws-switch.sh)
    (writers.writeBashBin "edex-ui" ''
      #!/usr/bin/env bash
      mpc clear
      mpc add GanstasUnixporn.mp3
      mpc play
      feh --bg-fill ~/Documents/Untitled.png
      ${pkgs.appimage-run}/bin/appimage-run ~/Desktop/eDEX-UI.AppImage --no-sandbox
    '')
  ];
}
