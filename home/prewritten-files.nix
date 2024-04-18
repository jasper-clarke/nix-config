{ 
  config, 
  lib, 
  pkgs, 
  ... 
}: {
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

      ".config/wireplumber/main.lua.d/99-alsa-speakers.lua".text = ''
        rule = {
          matches = {
            {
              { "alsa.card_name", "=", "Pebble V3" },
            }
          },
          apply_properties = {
            ["audio.channels"]         = 2,
            ["audio.position"]         = "FR,FL",
          },
        }

        table.insert(alsa_monitor.rules, rule)
      '';

      ".ssh/config".text = ''
        Host gitlab.com
          IdentityFile ~/.ssh/gitlab

        Host github.com
          IdentityFile ~/.ssh/gitlab
      '';

      ".config/nvim" = {
        source = ./neovim;
        recursive = true;
        force = true;
      };

    };
  };
}
