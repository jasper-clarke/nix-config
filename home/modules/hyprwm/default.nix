{
  config,
  lib,
  pkgs,
  inputs,
  user,
  ...
}: let
  appsRasi = ./apps.rasi;
in {
  imports = [
    ./waybar.nix
    ./swaylock.nix
  ];

  programs.wpaperd = {
    enable = true;
    settings = {
      any = {
        path = ../../../wallpapers/space.png;
        mode = "center";
      };
      "DP-1" = {
        path = ../../../wallpapers/space-resolved-scriptures.png;
        mode = "center";
      };
    };
  };

  services.mako = {
    enable = true;
    anchor = "top-right";
    font = "Inter Bold 12";
    backgroundColor = "#1A1B26";
    textColor = "#c0caf5";
    width = 350;
    margin = "0,20,20";
    padding = "10";
    borderSize = 2;
    borderColor = "#414868";
    borderRadius = 10;
    defaultTimeout = 10000;
    groupBy = "summary";
    output = "DP-1";
    maxVisible = 2;
    format = "<b>%s</b>\\n%b";
    layer = "overlay";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    # xwayland.enable = true;
    plugins = [
      # inputs.hyprgrass.packages.${pkgs.system}.default
    ];
    settings = {
      bind = [
        "SUPER, D, exec, rofi -show drun -theme ${appsRasi}"
        " , tap:3, exec, rofi -show drun -theme ${appsRasi}"
      ];
    };
    extraConfig = ''
      source = ~/.config/hypr/hypr.conf
      source = ~/.config/hypr/keys.conf
    '';
  };

  home = {
    packages = with pkgs; [
      hyprpicker
      wev
      grimblast
      rofi-wayland
      swappy

      ponymix
      (writers.writeBashBin "audio-select" ./scripts/audio-select)

      headsetcontrol
      (writers.writeBashBin "lights" ./scripts/lights.sh)

      (writers.writeBashBin "ws-switch" ./scripts/per-monitor-ws-switcher.sh)
    ];

    file = {
      ".config/hypr/hypr.conf".source = ./hyprland.conf;
      ".config/hypr/keys.conf".source = ./corne-keys.conf;
    };
  };
}
