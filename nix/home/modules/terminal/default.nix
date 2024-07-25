{
  inputs,
  pkgs,
  lib,
  config,
  user,
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
    programs = {
      kitty.enable = config.kitty;
      git.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
      oh-my-posh.enable = true;
      fzf.enable = true;
      yazi.enable = true;
      btop.enable = true;
    };

    home.packages = with pkgs; [
      tree
      killall
      nitch
      nix-output-monitor
      ffmpegthumbnailer
      trash-cli
      lazygit
      alejandra
      dust

      nodejs # Copilot requires
      neovim
      neovim-remote

      (nerdfonts.override {fonts = ["Iosevka"];})
      jetbrains-mono
    ];
  };
}
