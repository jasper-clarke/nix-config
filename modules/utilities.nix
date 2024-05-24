{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    printing = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Enable printing and scanning.
      '';
    };
  };

  config = {
    services = {
      printing = {
        enable = config.printing;
        drivers = [pkgs.cnijfilter2];
      };
      avahi.enable = config.printing;
    };

    environment.systemPackages = lib.mkIf config.printing [
      pkgs.gnome.simple-scan
      pkgs.sane-backends
    ];
  };
}
