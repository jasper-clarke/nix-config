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
      extraConfig.pipewire."99-rates" = {
        context.properties = {
          default.clock.rate = 192000;
          defautlt.allowed-rates = [192000];
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };
  };

  # environment.etc."pipewire/pipewire.conf.d/99-rates.conf".text = ''
  #   context.properties = {
  #     default.clock.rate = 192000
  #     default.clock.allowed-rates = [ 192000 ]
  #     default.clock.quantum = 32
  #     default.clock.min-quantum = 32
  #     default.clock.max-quantum = 32
  #   }
  # '';

  sound.enable = lib.mkForce false;
  hardware.pulseaudio.enable = lib.mkForce false;

  security.rtkit.enable = true;
}
