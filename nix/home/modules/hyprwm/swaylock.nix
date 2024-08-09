{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    sway-audio-idle-inhibit
    swayidle
  ];

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      daemonize = true;
      show-failed-attempts = true;
      clock = true;
      screenshot = true;
      ignore-empty-password = true;
      indicator = true;

      effect-blur = "15x15";
      color = "000";
      font = "Inter";
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = "1f1d2e";
      ring-color = "191724";
      inside-color = "1f1d2e";
      key-hl-color = "eb6f92";
      separator-color = "000000";
      text-color = "e0def4";
      text-caps-lock-color = "";
      line-ver-color = "eb6f92";
      ring-ver-color = "eb6f92";
      inside-ver-color = "1f1d2e";
      text-ver-color = "e0def4";
      ring-wrong-color = "31748f";
      text-wrong-color = "31748f";
      inside-wrong-color = "1f1d2e";
      inside-clear-color = "1f1d2e";
      text-clear-color = "e0def4";
      ring-clear-color = "9ccfd8";
      line-clear-color = "1f1d2e";
      line-wrong-color = "1f1d2e";
      bs-hl-color = "31748f";
      datestr = "%a, %B %e";
      timestr = "%I:%M %p";
    };
  };
}