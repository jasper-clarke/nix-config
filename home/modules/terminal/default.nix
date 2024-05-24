{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    kitty = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Enable kitty for the graphical terminal
      '';
    };
  };

  config = {
    programs.kitty = {
      enable = config.kitty;
      font.name = "Fira Code";
      font.package = pkgs.fira-code;
      font.size = 15;
      theme = "Tokyo Night";
      shellIntegration.enableZshIntegration = true;
      settings = {
        confirm_os_window_close = 0;
        enable_audio_bell = false;
        window_padding_width = 15;
        allow_remote_control = true;
        listen_on = "unix:/tmp/kitty";
      };
    };

    programs.git = {
      enable = true;
      userName = "jasper-at-windswept";
      userEmail = "jasper@windswept.digital";
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        cd = "z";
        rm = "trash-put";
      };
      initExtra = ''

        nitch

      '';
      oh-my-zsh = {
        enable = true;
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.nnn = {
      enable = true;
      package = pkgs.nnn.override {withNerdIcons = true;};
      bookmarks = {
        s = "/run/media/allusive/SSD";
        f = "~/.flake";
        d = "~/Downloads";
      };
      plugins = {
        mappings = {
          p = "preview-tui";
        };
        src =
          (pkgs.fetchFromGitHub {
            owner = "jarun";
            repo = "nnn";
            rev = "v4.9";
            sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
          })
          + "/plugins";
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = false;
        vim_keys = true;
      };
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    home.file.".config/starship.toml" = {
      source = ./tokyonight.toml;
      force = true;
    };

    home.packages = with pkgs; [
      tree
      killall
      nitch
      fzf
      nix-output-monitor
      imagemagick
      ffmpegthumbnailer
      trash-cli
      lazygit
      alejandra
      (nerdfonts.override {fonts = ["Iosevka"];})
      jetbrains-mono
    ];
  };
}
