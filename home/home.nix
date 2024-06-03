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
    ./spicetify.nix
    ./modules/terminal
    # ./modules/hyprwm
    ./modules/herbstluft
    ./modules/desktopApps
  ];

  kitty = true;
  browser = true;
  music = true;

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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
        colorVariants = ["dracula"];
      };
    };
    cursorTheme = {
      name = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
    };
    theme = {
      name = "Catppuccin-Macchiato-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        size = "standard";
        tweaks = ["normal"];
        variant = "macchiato";
      };
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
      bluetuith
      # wl-clipboard
      sops

      ponymix
      (writers.writeBashBin "audio-select" ./audio-select)

      headsetcontrol
      # (writers.writeBashBin "lights" ./scripts/lights.sh)

      # GUI Utils
      rofi
      xarchiver
      mpv
      feh
      onlyoffice-bin
      copyq
      motrix
      gimp
      marktext
      audacity

      prismlauncher

      # Development / Course
      teams-for-linux
      vscodium

      # (picom.overrideAttrs
      #   (oldAttrs: rec {
      #     version = "c282bb59f2fb09def989a22cfb2036d27d3979a5";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "yshui";
      #       repo = "picom";
      #       rev = version;
      #       hash = "sha256-sUVGlWmQrzvgbc7WNbX9H0T38uQF64rQSx7f4DtnBDY=";
      #     };
      #   }))
      #
      wmctrl
      calc
      xclip
      nitrogen
      flameshot
      betterlockscreen

      (picom.overrideAttrs (oldAttrs: rec {
        pname = "compfy";
        version = "1.7.2";
        buildInputs =
          [
            pcre2
          ]
          ++ oldAttrs.buildInputs;
        src = pkgs.fetchFromGitHub {
          owner = "allusive-dev";
          repo = "compfy";
          rev = version;
          hash = "sha256-7hvzwLEG5OpJzsrYa2AaIW8X0CPyOnTLxz+rgWteNYY=";
        };
        postInstall = '''';
      }))

      # Font Stuff
      liberation_ttf
      freetype
      source-han-sans
      inter
    ];
  };
}
