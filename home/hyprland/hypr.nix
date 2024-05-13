{
  config,
  lib,
  pkgs,
  hyprland,
  hyprgrass,
  user,
  ...
}: 
let
  appsRasi = ./apps.rasi;
in {

  programs.wpaperd = {
    enable = true;
    settings = {
      any = {
        path = "/home/${user}/.flake/wallpapers/space.png";
        mode = "center";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    plugins = [
      # hyprgrass.packages.${pkgs.system}.default
    ];
    settings = {
      bind = [
        "SUPER, D, exec, rofi -show drun -theme ${appsRasi}"
        " , tap:3, exec, rofi -show drun -theme ${appsRasi}"
        # "ALT, SPACE, exec, rofi -show drun -theme ${appsRasi}"
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
      swayidle
      wev
      grimblast
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
      ".config/hypr/keys.conf".source = ./corne-keys.conf;
    };
  };

}
