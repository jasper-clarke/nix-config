{
  pkgs,
  lib,
  config,
  ...
}: {
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # wireplumber.configPackages = [
      #   (pkgs.writeTextDir "share/wireplumber/main.lua.d/99-pebble-switch.lua" ''
      #     alsa_monitor.rules = {
      #       {
      #         matches = {
      #           {
      #             { "node.name", "matches", "*Pebble_V3*" },
      #           }
      #         },
      #         apply_properties = {
      #           ["audio.channels"]         = "2",
      #           ["audio.position"]         = "FR,FL",
      #         },
      #       }
      #     }
      #   '')
      # ];
    };
  };

  sound.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;

  security.rtkit.enable = true;
}
