{ config, lib, pkgs, ... }:

{
  home = {
    file = {

      ".config/wireplumber/main.lua.d/99-stop-microphone-auto-adjust.lua".text = ''
        table.insert (default_access.rules,{
            matches = {
                {
                    { "application.process.binary", "=", "electron" }
                }
            },
            default_permissions = "rx",
        })
      '';

      ".ssh/config".text = ''
        Host gitlab.com
          IdentityFile ~/.ssh/gitlab

        Host github.com
          IdentityFile ~/.ssh/gitlab
      '';


    };
  };
}
