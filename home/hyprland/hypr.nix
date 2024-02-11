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
    };
  };

  home.file = {
    ".config/hypr/hypr.conf".source = ./hyprland.conf;
  };

}