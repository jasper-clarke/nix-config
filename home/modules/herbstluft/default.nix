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

  home.file.".config/herbstluftwm/autostart" = {
    source = ./config;
    executable = true;
    force = true;
  };
}
