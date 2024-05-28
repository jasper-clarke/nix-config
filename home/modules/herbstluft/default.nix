{
  pkgs,
  lib,
  config,
  ...
}: {
  # xsession.windowManager.herbstluftwm = {
  #   enable = true;
  #   # extraConfig = builtins.readFile ./config;
  # };

  home.file = {
    ".config/herbstluftwm/autostart" = {
      source = ./config;
      executable = true;
      force = true;
    };

    ".config/nitrogen/bg-saved.cfg".text = ''
      [xin_0]
      file=${../../../wallpapers/space.png}
      mode=5
      bgcolor=#000000

      [xin_1]
      file=${../../../wallpapers/space-resolved-scriptures.png}
      mode=5
      bgcolor=#000000

      [xin_2]
      file=${../../../wallpapers/space.png}
      mode=5
      bgcolor=#000000
    '';

    ".config/polybar/config.ini" = {
      source = ./polybar.ini;
      force = true;
    };
  };
}
