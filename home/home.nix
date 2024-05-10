{
  config,
  lib,
  pkgs,
  user,
  version,
  hyprland,
  hyprgrass,
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
    # ./spicetify.nix
  ];
  
  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      userName = "jasper-at-windswept";
      userEmail = "jasper@windswept.digital";
    };

    firefox = {
      enable = true;
      nativeMessagingHosts = [ pkgs.tridactyl-native ];
      profiles.allusive = {
        isDefault = true;
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          darkreader
          ublock-origin
          violentmonkey
          tridactyl
        ];
        settings = {
          "browser.toolbars.bookmarks.visibility" = "always";
          "media.getusermedia.aec_enabled" = false;
          "media.getusermedia.agc_enabled" = false;
          "media.getusermedia.noise_enabled" = false;
          "media.getusermedia.hpf_enabled" = false;
          "browser.tabs.tabmanager.enabled" = false;
          "browser.gesture.pinch.in" = false;
          "browser.gesture.pinch.out" = false;
          # "gestures.enable_single_finger_input" = false;
          "apz.allow_zooming" = false;
          "apz.allow_double_tap_zooming" = false;

          "font.name.serif.x-western" = "JetBrains Mono";
        };
        search.default = "DuckDuckGo";
        search.force = true;
      };
    };

    nnn = {
      enable = true;
      package = pkgs.nnn.override ({ withNerdIcons = true; });
      bookmarks = {
        s = "/run/media/allusive/SSD";
        f = "~/.flake";
        d = "~/Downloads";
      };
      plugins = {
        src = (pkgs.fetchFromGitHub {
                owner = "jarun";
                repo = "nnn";
                rev = "v4.9";
                sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
              }) + "/plugins";
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["nnn.desktop"];
        "text/*" = ["neovim.desktop"];
        "text/javascript" = ["neovim.desktop"];
        "text/css" = ["neovim.desktop"];
        "application/x-desktop" = ["neovim.desktop"];
        "application/yaml" = ["neovim.desktop"];
        "application/json" = ["neovim.desktop"];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice.desktop"];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice.desktop"];
        "application/pdf" = ["firefox.desktop"];
        "application/zip" = ["xarchiver.desktop"];
        "video/*" = ["mpv.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/mailto" = ["firefox.desktop"];
        "image/*" = ["feh.desktop"];
        "image/png" = ["feh.desktop"];
        "image/jpeg" = ["feh.desktop"];
      };
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
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

      # CLI
      tree
      killall
      lsd
      calc
      nitch
      fzf
      btop
      bluetuith
      nix-output-monitor
      wl-clipboard
      trash-cli
      sops

      # GUI Utils
      # gnome.nautilus
      xarchiver
      mpv
      feh
      onlyoffice-bin
      copyq
      # gnome.simple-scan
      motrix
      gimp
      # scribus
      marktext
      audacity

      # Apps
      steam
      # figma-linux
      # prismlauncher

      # Libraries
      # temurin-jre-bin-17

      # Development / Course
      teams-for-linux
      # jetbrains-toolbox
      vscodium

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
