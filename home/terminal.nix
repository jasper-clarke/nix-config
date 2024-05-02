{
  config,
  lib,
  pkgs,
  user,
  ...
}: {
  programs.kitty = {
    enable = true;
    #font.package = pkgs.roboto;
    font.name = "JetBrains Mono";
    font.size = 15;
    theme = "Tokyo Night";
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 15;
    };
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
    # sessionVariables = {
    #   LD_LIBRARY_PATH = "$LD_LIBRARY_PATH:${ with pkgs; lib.makeLibraryPath [
    #     wayland
    #     libxkbcommon
    #     fontconfig
    #   ] }";
    # };
    shellAliases = {
      # rebuild-switch = "rm ~/.config/mimeapps.list && sudo nixos-rebuild switch --flake /home/${user}/.flake#nixos";
      rust = "cd /run/media/allusive/SSD/Projects/Rust && nohup rust-rover &";
      web = "cd /run/media/allusive/SSD/Projects/NodeProjects && nohup webstorm &";
      cd = "z";
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

  home.file.".config/starship.toml" = {
    source = ./tokyonight.toml;
    force = true;
  };

  # programs.oh-my-posh = {
  #  enable = true;
  #  enableZshIntegration = true;
  #  useTheme = "sonicboom_dark";
  #  settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./bubbles.omp.json));
  # };
}
