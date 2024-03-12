{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
  spicetify-nix = inputs.spicetify-nix;
in {
  # allow spotify to be installed if you don't have unfree enabled already
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "spotify"
    ];

  # import the flake's module for your system
  imports = [spicetify-nix.homeManagerModule];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "catppuccin-macchiato";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      hidePodcasts
      adblock
    ];
  };
}
