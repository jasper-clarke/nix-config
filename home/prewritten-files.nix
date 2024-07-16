{
  config,
  lib,
  pkgs,
  ...
}: {
  home = {
    file = {
      # ".config/wireplumber/main.lua.d/99-stop-microphone-auto-adjust.lua".text = ''
      #   table.insert (default_access.rules,{
      #       matches = {
      #           {
      #               { "application.process.binary", "=", "electron" }
      #           }
      #       },
      #       default_permissions = "rx",
      #   })
      # '';

      ".config/wireplumber/wireplumber.conf.d/pebble-v3.conf".text = ''
        monitor.alsa.rules = [
          {
            matches = [
              {
                node.name = "~alsa_output.usb-ACTIONS_Pebble_V3-00.*",
              }
            ]
            actions = {
              update-props = {
                audio.position = ["FR", "FL"],
              }
            }
          }
        ]
      '';

      ".config/kitty/nodenvim.conf".text = ''
        layout tall:bias=25;full_size=1;mirrored=true

        cd ~/Projects/NodeProjects

        launch --type=tab nix-shell --command zsh
        launch --type=tab nix-shell --command zsh --run "nvim --listen /tmp/nvimsocket"
        launch --type=tab nix-shell --command zsh
        resize_window shorter 12
      '';

      ".config/kitty/gleamnvim.conf".text = ''
        layout tall:bias=25;full_size=1;mirrored=true

        cd ~/Projects/Gleam

        launch --type=tab nix-shell --command zsh
        launch --type=tab nix-shell --command zsh --run "nvim --listen /tmp/nvimsocket"
        launch --type=tab nix-shell --command zsh
        resize_window shorter 12
      '';

      ".config/kitty/phpnvim.conf".text = ''
        layout tall:bias=25;full_size=1;mirrored=true

        cd ~/Projects/PHP

        launch --type=tab nix-shell --command zsh
        launch --type=tab nix-shell --command zsh --run "nvim --listen /tmp/nvimsocket"
        launch --type=tab nix-shell --command zsh
        resize_window shorter 12
      '';

      ".ssh/config".text = ''
        Host gitlab.com
          IdentityFile ~/.ssh/gitlab

        Host github.com
          IdentityFile ~/.ssh/gitlab

        Host 192.168.100.133
          IdentityFile ~/.ssh/private
      '';

      # ".config/phpactor/phpactor.json".text = ''
      #   {
      #       "language_server_phpstan.enabled": true
      #   }
      # '';

      # ".local/share/fonts/SF-Mono" = {
      #   source = ../fonts/SF-Mono;
      #   recursive = true;
      #   # force = true;
      # };

      ".local/share/fonts/SF-Pro" = {
        source = ../fonts/SF-Pro;
        recursive = true;
        # force = true;
      };

      # ".config/awesome" = {
      #   source = ../awesome;
      #   recursive = true;
      #   force = true;
      # };

      ".local/share/applications/feh.desktop".text = ''
        [Desktop Entry]
        Name=Feh (Scaled)
        Name[en_US]=feh
        GenericName=Image viewer
        GenericName[en_US]=Image viewer
        Comment=Image viewer and cataloguer
        Exec=feh --scale-down %F
        Terminal=false
        Type=Application
        Icon=feh
        Categories=Graphics;2DGraphics;Viewer;
        MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/pjpeg;image/png;image/tiff;image/webp;image/x-bmp;image/x-pcx;image/x-png;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-tga;image/x-xbitmap;image/heic;
        NoDisplay=true
      '';

      ".local/share/applications/onlyoffice.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Name=Only Office
        GenericName=Document Editor
        Comment=Edit office documents
        Type=Application
        Exec=onlyoffice-desktopeditors %F
        Terminal=false
        Icon=onlyoffice-desktopeditors
        Keywords=Text;Document;OpenDocument Text;Microsoft Word;Microsoft Works;odt;doc;docx;rtf;
        Categories=Office;WordProcessor;Spreadsheet;Presentation;
      '';

      ".local/share/applications/neovim.desktop".text = ''
        [Desktop Entry]
        Name=Neovim
        GenericName=Text Editor
        Comment=Edit text files
        Exec=kitty -e nvim %F
        Terminal=false
        Type=Application
        Keywords=Text;editor;
        Icon=nvim
        Categories=Utility;TextEditor;
        StartupNotify=false
        MimeType=text/english;text/plain;text/x-makefile;text/x-c++hdr;text/x-c++src;text/x-chdr;text/x-csrc;text/x-java;text/x-moc;text/x-pascal;text/x-tcl;text/x-tex;application/x-shellscript;text/x-c;text/x-c++;
      '';

      ".local/share/applications/yazi-custom.desktop".text = ''
        [Desktop Entry]
        Type=Application
        Name=yazi
        Comment=Terminal file manager
        Exec=kitty -e yazi %F
        Terminal=false
        Icon=nnn
        MimeType=inode/directory
        Categories=System;FileTools;FileManager;ConsoleOnly
        Keywords=File;Manager;Management;Explorer;Launcher
      '';
    };
  };
}
