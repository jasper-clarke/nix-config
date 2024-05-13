{ pkgs, lib, config, user, ...}:

{
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    protonup
    mangohud
  ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${user}/.steam/root/compatibilitytools.d";
  };
}
