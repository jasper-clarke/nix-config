{
  config,
  lib,
  pkgs,
  user,
  version,
  hyprland,
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
      profiles.allusive = {
        isDefault = true;
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

    # neovim = {
    #   enable = true;
    #   plugins = with pkgs.vimPlugins; [
    #     dashboard-nvim
    #     nvim-cmp
    #     LeaderF
    #     nvim-tree-lua
    #   ];
    #   defaultEditor = true;
    # };

  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["org.gnome.Nautilus.desktop"];
        "text/*" = ["codium.desktop"];
        "text/plain" = ["codium.desktop"];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice-desktopeditors.desktop"];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice-desktopeditors.desktop"];
        "application/pdf" = ["firefox.desktop"];
        "application/zip" = ["xarchiver.desktop"];
        "video/*" = ["mpv.desktop"];
        "x-scheme-handler/https" = ["firefox.desktop"];
        "x-scheme-handler/http" = ["firefox.desktop"];
        "x-scheme-handler/mailto" = ["firefox.desktop"];
        "image/*" = ["firefox.desktop"];
        "image/png" = ["firefox.desktop"];
        "image/jpeg" = ["firefox.desktop"];
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
      zsh
      tree
      killall
      lsd
      calc
      nitch
      fzf
      btop

      # GUI Utils
      gnome.nautilus
      xarchiver
      mpv
      feh
      onlyoffice-bin
      copyq
      gnome.simple-scan
      motrix
      gimp
      # scribus
      marktext
      helvum
      audacity

      # Apps
      steam
      prismlauncher
      figma-linux

      # Libraries
      temurin-jre-bin-17

      # Development / Course
      teams-for-linux
      jetbrains-toolbox
      vscodium
      lapce

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
