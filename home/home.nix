{
  config,
  lib,
  pkgs,
  user,
  version,
  system,
  inputs,
  ...
}: {

  imports = [
    ./prewritten-files.nix
    ./terminal.nix
  ];

  xresources.extraConfig = ''
   ! special
   *.foreground:   #edeff0
   *.background:   #0c0e0f

   ! black
   *.color0:       #232526
   *.color8:       #2c2e2f

   ! red
   *.color1:       #df5b61
   *.color9:       #e8646a

   ! green
   *.color2:       #78b892
   *.color10:      #81c19b

   ! yellow
   *.color3:       #de8f78
   *.color11:      #e79881

   ! blue
   *.color4:       #6791c9
   *.color12:      #709ad2

   ! magenta
   *.color5:       #bc83e3
   *.color13:      #c58cec

   ! cyan
   *.color6:       #67afc1
   *.color14:      #70b8ca

   ! white
   *color7:        #e4e6e7
   *color15:       #f2f4f5
  '';

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "jasper-at-windswept";
      userEmail = "jasper@windswept.digital";
    };

    firefox = {
      enable = true;
      profiles.allusive = {
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          darkreader
          firefox-color
          ublock-origin
          violentmonkey
        ];
        settings = {
          "browser.toolbars.bookmarks.visibility" = "always";
          "media.getusermedia.aec_enabled" = false;
          "media.getusermedia.agc_enabled" = false;
          "media.getusermedia.noise_enabled" = false;
          "media.getusermedia.hpf_enabled" = false;
          "browser.tabs.tabmanager.enabled" = false;

          "font.name.serif.x-western" = "JetBrains Mono";
        };
        search.default = "DuckDuckGo";
        search.force = true;
      };
    };

  };

  fonts.fontconfig.enable = true;

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["pcmanfm.desktop"];
        "text/plain" = ["emacsclient.desktop"];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice-desktopeditors.desktop"];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice-desktopeditors.desktop"];
        "application/pdf" = ["onlyoffice-desktopeditors.desktop"];
        "application/zip" = ["xarchiver.desktop"];
        "text/*" = ["emacsclient.desktop"];
        "video/*" = ["mpv.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/mailto" = ["firefox.desktop"];
        "image/*" = ["feh-custom.desktop"];
        "image/png" = ["feh-custom.desktop"];
        "image/jpeg" = ["feh-custom.desktop"];
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
    cursorTheme = {
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
    };
    theme = {
      name = "Awesthetic-dark";
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    stateVersion = "${version}";

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      size = 40;
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
    };

    packages = with pkgs; [
      zsh
      tree
      killall
      pcmanfm
      rofi
      kitty
      lsd
      starship
      xarchiver
      calc
      steam
      mpv
      feh
      vscodium
      emacs
      flameshot
      colorpicker
      nitch
      prismlauncher
      betterlockscreen
      playerctl
      onlyoffice-bin
      copyq
      #zulu8
      gnome.simple-scan
      motrix
      element-desktop
      xdotool
      headsetcontrol
      fzf
      gimp
      btop
      mpc-cli
      temurin-jre-bin-17
      nodejs
      nodePackages.pnpm
      ponymix
      spotdl
      ymuse
      appimage-run
      psi-notify
      scribus
      zettlr
      figma-linux
      helvum

      jetbrains.webstorm

      # Font Stuff
      (nerdfonts.override {fonts = ["Iosevka"];})
      jetbrains-mono
      liberation_ttf
      freetype
      source-han-sans
      inter

      # Customs
      (picom-next.overrideAttrs (oldAttrs: rec {
        pname = "compfy";
        version = "1.7.2";
        src = ../compfy;
        postInstall = '''';
      }))
    ];
  };
}
