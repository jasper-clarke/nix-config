{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./music.nix
    ./browser.nix
  ];
}
