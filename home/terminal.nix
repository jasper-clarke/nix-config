{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    #font.package = pkgs.inter;
    font.name = "Inter";
    font.size = 14;
    theme = "Gruvbox Material Dark Soft";
    #extraConfig = "include ~/.cache/wal/colors-kitty.conf";
    #extraConfig = ''
    #  background #000000
    #  background_opacity 0.0
    #'';
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 10;
    };
  };
}
