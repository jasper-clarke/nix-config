{
  config,
  lib,
  pkgs,
  hyprland,
  ...
}: 
let
  appsRasi = ./apps.rasi;
in {

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    settings = {
      source = "~/.config/hypr/hypr.conf";

      bind = [
        "ALT, SPACE, exec, rofi -show drun -theme ${appsRasi}" 
      ];
    };
  };

  home = {
    packages = with pkgs; [
      hyprpicker
      swayidle
      swww
      wev
      slurp
      grim
      rofi-wayland
      swappy
      sway-audio-idle-inhibit

      ponymix
      (writers.writeBashBin "audio-select" ../scripts/audio-select)

      headsetcontrol
      (writers.writeBashBin "lights" ../scripts/lights.sh)

      (writers.writeBashBin "ws-switch" ../scripts/per-monitor-ws-switcher.sh)

      playerctl
      mpc-cli
      (writers.writeBashBin "toggle-players" ../scripts/playerctl.sh)
    ];

    file = {
      ".config/hypr/hypr.conf".source = ./hyprland.conf;
    };
  };

}