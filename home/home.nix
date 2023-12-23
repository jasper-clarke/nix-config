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
  ];

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "allusive-dev";
      userEmail = "jasper@allusive.dev";
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

    # obs-studio = {
    #   enable = true;
    #   plugins = with pkgs.obs-studio-plugins; [
    #     obs-pipewire-audio-capture
    #   ];
    # };
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

  nixpkgs.config.allowUnfree = true;

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
      name = "Capitaine Cursors (Gruvbox) - White";
      package = pkgs.capitaine-cursors-themed;
    };
    theme = {
      name = "Gruvbox-Material-Dark";
    };
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    stateVersion = "${version}";

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      size = 38;
      name = "Capitaine Cursors (Gruvbox) - White";
      package = pkgs.capitaine-cursors-themed;
    };

    packages = with pkgs; [
      zsh
      tree
      obsidian
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
      wmctrl
      betterlockscreen
      playerctl
      onlyoffice-bin
      copyq
      #zulu8
      gnome.simple-scan
      motrix
      alarm-clock-applet
      element-desktop
      xdotool
      headsetcontrol
      fzf
      gimp
      trayer
      cmus
      polybar
      figma-linux

      signal-desktop
      btop

      bun

      helvum

      #inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.jetbrains.idea-community

      inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.audacity

      # Font Stuff
      (nerdfonts.override {fonts = ["Iosevka"];})
      jetbrains-mono
      liberation_ttf
      freetype
      source-han-sans
      inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.inter

      # Customs
      (picom.overrideAttrs (oldAttrs: rec {
        pname = "compfy";
        version = "1.7.2";
        buildInputs = [
          pcre2
        ]
        ++
          oldAttrs.buildInputs;
        src = ../compfy;
        postInstall = '''';
      }))
    ];
  };
}
