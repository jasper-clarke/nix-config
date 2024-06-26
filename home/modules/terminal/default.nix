{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  tmux_everforest = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux_everforest";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "jasper-at-windswept";
      repo = "tmux-everforest";
      rev = "cd602216a1e0112085c9b584b0e11e7d21409bfa";
      hash = "sha256-oQZLjiuA5KRWo7/s80SfNG6nOCsWViCEzm77/S4vp1w=";
    };
  };
in {
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
        background_opacity = "0.93";
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
        service-logs = "sudo journalctl -xefu";
      };
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];
      initExtraFirst = ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
      initExtra = ''
        source ~/.p10k.zsh
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
      '';
      # oh-my-zsh = {
      # enable = true;
      # };
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      tmux.enableShellIntegration = true;
    };

    # programs.starship = {
    #   enable = true;
    #   enableZshIntegration = true;
    # };

    # programs.nnn = {
    #   enable = true;
    #   package = pkgs.nnn.override {withNerdIcons = true;};
    #   bookmarks = {
    #     s = "/run/media/allusive/SSD";
    #     f = "~/.flake";
    #     d = "~/Downloads";
    #   };
    #   plugins = {
    #     mappings = {
    #       p = "preview-tui";
    #     };
    #     src =
    #       (pkgs.fetchFromGitHub {
    #         owner = "jarun";
    #         repo = "nnn";
    #         rev = "v4.9";
    #         sha256 = "sha256-g19uI36HyzTF2YUQKFP4DE2ZBsArGryVHhX79Y0XzhU=";
    #       })
    #       + "/plugins";
    #   };
    # };

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      plugins = {
        "full-border.yazi" = ./yazi_full-border;
        "smart-enter.yazi" = ./yazi_smart-enter;
      };
      initLua = ./yazi_init.lua;
      keymap = {
        manager.prepend_keymap = [
          {
            exec = "plugin --sync smart-enter";
            on = ["<Enter>"];
          }
        ];
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

    programs.tmux = {
      enable = true;
      prefix = "C-Space";
      keyMode = "vi";
      plugins = with pkgs; [
        {
          plugin = tmux_everforest;
          extraConfig = "set -g status-position top";
        }
        {
          plugin = tmuxPlugins.vim-tmux-navigator;
        }
      ];
      extraConfig = ''
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf
        bind-key \| split-window -h
        bind-key - split-window
        bind-key -n C-h select-pane -L
        bind-key -n C-j select-pane -D
        bind-key -n C-k select-pane -U
        bind-key -n C-l select-pane -R
      '';
    };

    home.file = {
      # ".config/starship.toml" = {
      #   source = ./everforest.toml;
      #   force = true;
      # };

      ".p10k.zsh" = {
        source = ./p10k.zsh;
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
