{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    #font.package = pkgs.roboto;
    font.name = "Inter";
    font.size = 14;
    theme = "Catppuccin-Mocha";
    # extraConfig = ''
    #   foreground   #edeff0
    #   background   #0c0e0f

    #   color0       #232526
    #   color8       #2c2e2f

    #   color1       #df5b61
    #   color9       #e8646a

    #   color2       #78b892
    #   color10      #81c19b

    #   color3       #de8f78
    #   color11      #e79881

    #   color4       #6791c9
    #   color12      #709ad2

    #   color5       #bc83e3
    #   color13      #c58cec

    #   color6       #67afc1
    #   color14      #70b8ca

    #   color7        #e4e6e7
    #   color15       #f2f4f5

    #   symbol_map U+ebe4 MaterialIcons
    # '';
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 10;
    };
  };
}
