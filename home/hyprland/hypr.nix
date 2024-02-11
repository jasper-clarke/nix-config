{
  config,
  lib,
  pkgs,
  hyprland,
  hycov,
  ...
}: 
let
  appsRasi = ./apps.rasi;
in {

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    plugins = [
      hycov.packages.${pkgs.system}.hycov
    ];
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

      ponymix
      (writeShellScriptBin "audio-select" ../scripts/audio-select)

      headsetcontrol
      (writeShellScriptBin "lights" ../scripts/lights.sh)
    ];

    file = {
      ".config/hypr/hypr.conf".source = ./hyprland.conf;
    };
  };

}