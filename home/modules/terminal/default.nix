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
      font.name = "JetBrains Mono";
      # font.package = pkgs.fira-code;
      font.size = 15;
      # theme = "Tokyo Night";
      theme = "Everforest Dark Hard";
      # theme = "Gruvbox Material Dark Medium";
      # theme = "Monokai Pro (Filter Ristretto)";
      shellIntegration.enableZshIntegration = true;
      settings = {
        confirm_os_window_close = 0;
        repaint_delay = 7;
        sync_to_monitor = true;
        enable_audio_bell = false;
        background_opacity = "0.94";
        window_padding_width = 15;
        allow_remote_control = true;
        listen_on = "unix:/tmp/kitty";
      };
    };

    # programs.wezterm = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   extraConfig = ''
    #     local wezterm = require("wezterm")
    #     local gpus = wezterm.gui.enumerate_gpus()
    #
    #     local config = {
    #       font = wezterm.font("JetBrains Mono"),
    #       font_size = 15.0,
    #       color_scheme = 'everforest',
    #       color_scheme_dirs = { os.getenv("HOME") .. "/.config/wezterm/colors/" },
    #       hide_tab_bar_if_only_one_tab = true,
    #       window_background_opacity = 0.9,
    #       enable_wayland = false,
    #       window_padding = {
    #         left = 15,
    #         right = 15,
    #         top = 15,
    #         bottom = 15,
    #       },
    #       cursor_blink_rate = 0,
    #       animation_fps = 1,
    #       cursor_blink_ease_in = "Constant",
    #       cursor_blink_ease_out = "Constant",
    #       audible_bell = "Disabled",
    #       check_for_updates = false,
    #       webgpu_preferred_adapter = gpus[1],
    #       front_end = "WebGpu",
    #     }
    #
    #     return config
    #   '';
    # };

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

    home.file = {
      ".config/starship.toml" = {
        source = ./everforest.toml;
        force = true;
      };

      # ".config/wezterm/colors/everforest.toml" = {
      #   source = ./wez-everforest.toml;
      #   force = true;
      # };

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
      stylua
      (nerdfonts.override {fonts = ["Iosevka"];})
      jetbrains-mono
    ];
  };
}
