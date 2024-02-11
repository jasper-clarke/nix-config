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
    # settings = {
    #   source = "~/.config/hypr/main.conf";
    # };
  };

  home.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
  };

}