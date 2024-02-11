{
  config,
  lib,
  pkgs,
  hyprland,
  hycov,
  ...
}: 
let
  appsRasi = ./apps.rasi;
in {

  wayland.windowManager.hyprland = {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    plugins = [
      hycov.packages.${pkgs.system}.hycov
    ];
    # settings = {
    #   source = "~/.config/hypr/main.conf";
    # };

    extraConfig = ''
      exec-once = swww init
      exec-once = waybar
      exec-once = copyq &
      exec-once = firefox https://wol.jw.org/en/wol/h/r1/lp-e
      exec-once = mpDris2 --music-dir=~/Music
      exec-once = psi-notify
      exec-once = lights
      exec-once = swayidle -w timeout 900 'swaylock -f'
    '' + ''

      env = XCURSOR_SIZE,40
      env = LIBVA_DRIVER_NAME,nvidia
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1
      env = NIXOS_OZONE_WL,1
    '' + ''

      plugin {
          hycov {
              overview_gappo = 60
              overview_gappi = 24
              enable_hotarea = 0
              enable_alt_release_exit = 1
              only_active_monitor = 1
              alt_toggle_auto_next = 1
          }
      }
    '' + ''

      input {
          kb_layout = us
          follow_mouse = 1
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }
    '' + ''

      general {
          gaps_in = 10
          gaps_out = 30
          border_size = 0
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)

          layout = dwindle

          allow_tearing = false
      }
    '' + ''

      misc {
          no_direct_scanout = yes
      }
    '' + ''

      dwindle {
          pseudotile = yes
          preserve_split = yes
      }
    '' + ''

      animations {
          enabled = yes
          bezier = wind, 0.05, 0.9, 0.1, 1.05
          bezier = winIn, 0.05, 0.7, 0.1, 1
          bezier = winOut, 0.3, -0.3, 0, 1
          bezier = liner, 1, 1, 1, 1
          animation = windows, 1, 4, wind, slide
          animation = windowsIn, 1, 3, winIn, popin
          animation = windowsOut, 1, 5, winOut, slide
          animation = windowsMove, 1, 5, wind, slide
          animation = border, 1, 1, liner
          animation = borderangle, 1, 30, liner, loop
          animation = fade, 1, 5, default
          animation = workspaces, 1, 5, wind
      }
    '' + ''

      monitor=DP-2, 2560x1440@120, 0x0, 1
      monitor=DP-1, 1920x1080@120, 2560x0, 1, transform, 3

      workspace = 1, monitor:DP-2, default:true
      workspace = 2, monitor:DP-2
      workspace = 3, monitor:DP-2
      workspace = 4, monitor:DP-1
      workspace = 5, monitor:DP-1
      workspace = 6, monitor:DP-1
    '' + ''

      bind = SUPER SHIFT, RETURN, exec, kitty
      bind = SUPER SHIFT, C, killactive
      bind = SUPER, F, togglefloating
      bind = SUPER, F1, exec, swaylock
      bind = SUPER, F2, fullscreen
      bind = SUPER, P, pseudo
      bind = SUPER, J, togglesplit 
      bind = SUPER, V, exec, copyq toggle
      bind = ALT, bracketleft, exec, mpc previous
      bind = ALT, bracketright, exec, mpc next

      bind = ALT, tab, hycov:toggleoverview

      bind = ALT, SPACE, exec, rofi -show drun -theme ${appsRasi}
      bind = SUPER SHIFT, Q, exec, wlogout -b 3 -c 0 -r 0 -m 0 --layout ~/.config/wlogout/layout_2 --css ~/.config/wlogout/style_2.css --protocol layer-shell
      bind = ,XF86AudioPlay, exec, playerctl play-pause 
      bind = ,XF86TouchpadOn, exec, wpctl set-volume @DEFAULT_SINK@ 5%-
      bind = ,XF86TouchpadOff, exec, wpctl set-volume @DEFAULT_SINK@ 5%+
      bind = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%-
      bind = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_SINK@ 5%+
      bind = SUPER, XF86AudioMicMute, exec, audio-select sink
      bind = ALT, XF86AudioMicMute, exec, audio-select source
      bind = SUPER SHIFT, S, exec, grim -g "$(slurp)" - | swappy -f -

      # Move focus with mainMod + arrow keys
      bind = SUPER, left, movefocus, l
      bind = SUPER, right, movefocus, r
      bind = SUPER, up, movefocus, u
      bind = SUPER, down, movefocus, d

      # Switch workspaces with mainMod + [0-9]
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6

      # Move active window to a workspace with mainMod + SHIFT + [0-9]
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6

      # Example special workspace (scratchpad)
      bind = SUPER, X, togglespecialworkspace, magicrofi
      bind = SUPER SHIFT, X, movetoworkspace, special:magic

      bind = SUPER, bracketleft, focusmonitor, l
      bind = SUPER, bracketright, focusmonitor, r
      bind = SUPER SHIFT, bracketleft, movewindow, l
      bind = SUPER SHIFT, bracketright, movewindow, r

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
    '' + ''

      windowrulev2 = float,class:(copyq)

      windowrulev2 = opacity 0.90 0.90,class:^(firefox)$
      windowrulev2 = opacity 0.80 0.80,class:^(Steam)$
      windowrulev2 = opacity 0.80 0.80,class:^(steam)$
      windowrulev2 = opacity 0.80 0.80,class:^(steamwebhelper)$
      windowrulev2 = opacity 0.80 0.80,class:^(Codium)$
      windowrulev2 = opacity 0.80 0.80,class:^(code-url-handler)$
      windowrulev2 = opacity 0.80 0.80,class:^(kitty)$
      windowrulev2 = opacity 0.80 0.80,class:^(qt5ct)$
    '' + ''

      group {
          col.border_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
          col.border_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
          col.border_locked_active = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
          col.border_locked_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
      }
    '' + ''

      decoration {
          rounding = 16

          blur {
              enabled = true
              special = false
              new_optimizations = on

              size = 10
              passes = 4
              brightness = 1
              noise = 0.01
              contrast = 1
              ignore_opacity = on
              xray = false

          }
          # Shadow
          drop_shadow = true
          shadow_ignore_window = true
          shadow_range = 15
          shadow_offset = 0 2
          shadow_render_power = 6
          col.shadow = rgba(00000044)
      }
    '';

  };

}