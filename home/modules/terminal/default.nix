{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  tmux-which-key = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "plugin.sh";
    version = "1.0";
    src = pkgs.fetchFromGitHub {
      owner = "alexwforsythe";
      repo = "tmux-which-key";
      rev = "b4cd9d28da4d0a418d2af5f426a0d4b4e544ae10";
      hash = "sha256-ADUgh0sSs1N2AsLC7+LzZ8UPGnmMqvythy97lK4fYgw=";
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
      font.size = 15;
      # theme = "Tokyo Night";
      theme = "Everforest Dark Hard";
      # theme = "Gruvbox Material Dark Medium";
      # theme = "Monokai Pro (Filter Ristretto)";
      shellIntegration.enableZshIntegration = true;
      settings = {
        confirm_os_window_close = 0;
        sync_to_monitor = true;
        enable_audio_bell = false;
        background_opacity = "0.93";
        window_padding_width = 15;
        # allow_remote_control = true;
        # listen_on = "unix:/tmp/kitty";
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
      autosuggestion = {
        enable = true;
        highlight = "fg=8";
      };
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        cd = "z";
        rm = "trash-put";
        service-logs = "sudo journalctl -xefu";
      };
      # plugins = [
      #   {
      #     name = "powerlevel10k";
      #     src = pkgs.zsh-powerlevel10k;
      #     file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      #   }
      # ];
      # initExtraFirst = ''
      #   if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
      #     source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      #   fi
      # '';
      # initExtra = ''
      #   source ~/.p10k.zsh
      # '';
    };

    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile ./p10k.omp.toml));
    };

    programs.fzf = {
      enable = true;
      # enableZshIntegration = true;
    };

    # programs.zellij = {
    #   enable = true;
    #   enableZshIntegration = true;
    #   settings = {
    #     theme = "everforest-dark";
    #     default_shell = "zsh";
    #     ui.pane_frames = {
    #       rounded_corners = true;
    #       hide_session_name = true;
    #     };
    #   };
    # };

    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      plugins = {
        "full-border" = ./yazi_full-border;
        "smart-enter" = ./yazi_smart-enter;
      };
      initLua = ./yazi_init.lua;
      keymap = {
        manager.prepend_keymap = [
          {
            run = "plugin --sync smart-enter";
            on = ["<Enter>"];
          }
        ];
      };
    };

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "matcha-dark-sea";
        theme_background = false;
        vim_keys = true;
      };
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    # programs.tmux = {
    #   enable = true;
    #   prefix = "C-Space";
    #   keyMode = "vi";
    #   plugins = with pkgs; [
    #     {
    #       plugin = tmuxPlugins.vim-tmux-navigator;
    #     }
    #     {
    #       plugin = tmuxPlugins.tmux-fzf;
    #     }
    #     # {
    #     #   plugin = tmux-which-key;
    #     # }
    #   ];
    #   extraConfig = builtins.readFile ./tmux.conf;
    # };

    home.file = {
      # ".p10k.zsh" = {
      #   source = ./p10k.zsh;
      #   force = true;
      # };

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
