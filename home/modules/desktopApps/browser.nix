{
  pkgs,
  lib,
  config,
  user,
  inputs,
  ...
}: {
  options = {
    browser = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Enable Firefox with all its extensions
      '';
    };
  };

  config = lib.mkIf config.browser {
    programs.firefox = {
      enable = true;
      nativeMessagingHosts = [pkgs.tridactyl-native];
      profiles.${user} = {
        isDefault = true;
        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          bitwarden
          darkreader
          ublock-origin
          violentmonkey
          tridactyl
        ];
        settings = {
          "browser.toolbars.bookmarks.visibility" = "always";
          "media.getusermedia.aec_enabled" = false;
          "media.getusermedia.agc_enabled" = false;
          "media.getusermedia.noise_enabled" = false;
          "media.getusermedia.hpf_enabled" = false;
          "browser.tabs.tabmanager.enabled" = false;
          "browser.gesture.pinch.in" = false;
          "browser.gesture.pinch.out" = false;
          # "gestures.enable_single_finger_input" = false;
          "apz.allow_zooming" = false;
          "apz.allow_double_tap_zooming" = false;

          "security.fileuri.strict_origin_policy" = false;

          "font.name.serif.x-western" = "JetBrains Mono";
        };
        search.default = "DuckDuckGo";
        search.force = true;
      };
    };
  };
}
