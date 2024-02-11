{
  config,
  lib,
  pkgs,
  user,
  version,
  hyprland,
  hycov,
  system,
  inputs,
  ...
}: {

  imports = [
    ./prewritten-files.nix
    ./terminal.nix
    ./hyprland/hypr.nix
    ./waybar.nix
    ./swaylock.nix
    ./ncmpcpp.nix
  ];

  # xresources.extraConfig = ''
  #  ! special
  #  *.foreground:   #edeff0
  #  *.background:   #0c0e0f

  #  ! black
  #  *.color0:       #232526
  #  *.color8:       #2c2e2f

  #  ! red
  #  *.color1:       #df5b61
  #  *.color9:       #e8646a

  #  ! green
  #  *.color2:       #78b892
  #  *.color10:      #81c19b

  #  ! yellow
  #  *.color3:       #de8f78
  #  *.color11:      #e79881

  #  ! blue
  #  *.color4:       #6791c9
  #  *.color12:      #709ad2

  #  ! magenta
  #  *.color5:       #bc83e3
  #  *.color13:      #c58cec

  #  ! cyan
  #  *.color6:       #67afc1
  #  *.color14:      #70b8ca

  #  ! white
  #  *color7:        #e4e6e7
  #  *color15:       #f2f4f5
  # '';

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
        "text/plain" = ["codium.desktop"];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice-desktopeditors.desktop"];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice-desktopeditors.desktop"];
        "application/pdf" = ["onlyoffice-desktopeditors.desktop"];
        "application/zip" = ["xarchiver.desktop"];
        "text/*" = ["codium.desktop"];
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
      name = "Tela-circle-dracula";
      package = pkgs.tela-circle-icon-theme.override {
        colorVariants = [ "dracula" ];
      };
    };
    cursorTheme = {
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
    };
    theme = {
      name = "Catppuccin-Macchiato-Standard-Pink-Dark";
      package = (pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        size = "standard";
        tweaks = [ "normal" ];
        variant = "macchiato";
      });
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    stateVersion = "${version}";

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      size = 44;
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
    };

    packages = with pkgs; [
      zsh
      tree
      killall
      pcmanfm
      kitty
      lsd
      starship
      xarchiver
      calc
      steam
      mpv
      feh
      vscodium
      # flameshot
      # colorpicker
      nitch
      prismlauncher
      playerctl
      onlyoffice-bin
      copyq
      gnome.simple-scan
      motrix
      # xdotool
      headsetcontrol
      fzf
      gimp
      btop
      mpc-cli
      temurin-jre-bin-17
      nodejs
      nodePackages.pnpm
      ymuse
      psi-notify
      scribus
      zettlr
      figma-linux
      helvum
      audacity
      # (ncmpcpp.override {
      #   visualizerSupport = true;
      # })
      libnotify

      teams-for-linux

      swappy
      grim
      slurp
      rofi-wayland
      hyprpicker
      wev
      swww
      swayidle

      jetbrains.webstorm

      # Font Stuff
      (nerdfonts.override {fonts = ["Iosevka"];})
      jetbrains-mono
      liberation_ttf
      freetype
      source-han-sans
      inter

      # Customs
      # (picom-next.overrideAttrs (oldAttrs: rec {
      #   pname = "compfy";
      #   version = "1.7.2";
      #   src = ../compfy;
      #   postInstall = '''';
      # }))
    ];
  };
}
