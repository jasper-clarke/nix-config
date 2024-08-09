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
    ./modules/everblush
    ./modules/desktopApps
  ];

  kitty = true;
  browser = true;
  music = true;

  programs.home-manager.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.fontconfig.enable = true;

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["yazi-custom.desktop"];
        "text/*" = ["neovide.desktop"];
        "text/javascript" = ["neovide.desktop"];
        "application/x-desktop" = ["neovide.desktop"];
        "application/yaml" = ["neovide.desktop"];
        "application/json" = ["neovide.desktop"];
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = ["onlyoffice.desktop"];
        "application/vnd.openxmlformats-officedocument.presentationml.presentation" = ["onlyoffice.desktop"];
        "application/pdf" = ["firefox.desktop"];
        "application/zip" = ["xarchiver.desktop"];
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "WhiteSur-dark";
      package = pkgs.whitesur-icon-theme;
    };
    # theme = {
    #   name = "Catppuccin-Macchiato-Standard-Pink-Dark";
    #   package = pkgs.catppuccin-gtk.override {
    #     accents = ["pink"];
    #     size = "standard";
    #     tweaks = ["normal"];
    #     variant = "macchiato";
    #   };
    # };
    theme = {
      name = "Everforest-Dark-BL";
      package = pkgs.everforest-gtk-theme;
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
      rofi
      xarchiver
      mpv
      feh
      onlyoffice-bin
      libreoffice-qt6-fresh
      copyq
      motrix
      gimp
      marktext
      audacity
      vscodium
      neovide

      ryujinx
      prismlauncher
      jetbrains.idea-ultimate

      # (
      #   picom.overrideAttrs
      #   (oldAttrs: rec {
      #     version = "270bcc45ac0d940fec4c7eb79aced7ab08ea9459";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "yshui";
      #       repo = "picom";
      #       rev = version;
      #       hash = "sha256-ZUFgEjK3lZ+g1kyXnLOxITkY+WQ5YZVk/5bvpKHaYsk=";
      #     };
      #   })
      # )

      wmctrl
      calc
      xclip
      nitrogen
      flameshot
      betterlockscreen
      ddcutil
      dotnet-sdk_8

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
