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
    ./modules/terminal
    ./modules/hyprwm
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
      wl-clipboard
      sops

      # GUI Utils
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

      # Font Stuff
      liberation_ttf
      freetype
      source-han-sans
      inter
    ];
  };
}
