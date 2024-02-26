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
    font.name = "Inter";
    font.size = 14;
    theme = "Catppuccin-Mocha";
    shellIntegration.enableZshIntegration = true;
    settings = {
      confirm_os_window_close = 0;
      enable_audio_bell = false;
      window_padding_width = 15;
    };
  };

  # home = {
  #   packages = [
  #     pkgs.wezterm
  #   ];
  #   file = {
  #     ".config/wezterm/wezterm.lua".source = ./wezterm.lua;
  #   };
  # };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
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
      rebuild-switch = "rm ~/.config/mimeapps.list && sudo nixos-rebuild switch --flake /home/${user}/.flake#nixos";
      rust = "cd ~/Projects/Rust && nohup rust-rover &";
      web = "cd ~/Projects/NodeProjects && nohup webstorm &";
      brun = "bun --bun run dev";
    };
    initExtra = ''

      nitch
      echo "Finished other maps up to the end of SWR"

    '';
    oh-my-zsh = {
      enable = true;
    };
  };

  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./bubbles.omp.json));
  };
}
