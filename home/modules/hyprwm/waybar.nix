{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        output = ["DP-1"];
        mod = "dock";
        exclusive = true;
        passtrough = false;
        gtk-layer-shell = true;
        height = 32;
        fixed-center = true;
        reload_style_on_change = true;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "mpd"
        ];

        modules-right = [
          "pulseaudio"
          "tray"
          "clock"
        ];

        "custom/keeb-batt" = {
          format = "{}";
          exec = "bluetoothctl info | grep 'Battery Percentage:' | sed -e 's/^[ \t]*//' | awk '{print $4}'";
          interval = 600;
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          active-only = false;
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "6" = "";
          };
          persistent-workspaces = {
            "*" = 1;
          };
        };

        "mpd" = {
          format = "{title}";
          format-disconnected = "Disconnected ";
          format-stopped = " ";
          interval = 10;
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
        };

        "tray" = {
          icon-size = 14;
          tooltip = false;
          spacing = 10;
        };

        "clock" = {
          format = "{:%I:%M %p}";
          format-alt = "{:%d/%m/%y}";
          tooltip-format = "<tt>{calendar}</tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b>{}</b></span>";
            };
          };
        };

        "pulseaudio" = {
          format = "  {volume}%";
          tooltip = false;
          format-muted = "  N/A";
          scroll-step = 5;
          on-click = "audio-select sink";
        };
      };
    };
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: Inter;
          font-size: 13px;
          border-radius: 17px;
      }

      #clock,
      #custom-notification,
      #custom-launcher,
      #custom-power-menu,
      /*#custom-colorpicker,*/
      #custom-window,
      #memory,
      #disk,
      #network,
      #battery,
      #custom-keeb-batt,
      #pulseaudio,
      #window,
      #tray {
          padding: 5 15px;
          border-radius: 12px;
          background: #1e1e2e;
          color: #b4befe;
          margin-top: 8px;
          margin-bottom: 8px;
          margin-right: 2px;
          margin-left: 2px;
          transition: all 0.3s ease;
      }

      #mpd {
          padding: 5 55px;
          border-radius: 12px;
          background-image: url("cover.jpg"), url("cover.png");
          background-position: center;
          background-repeat: no-repeat;
          background-size: cover;
          color: #FFF;
          margin-top: 8px;
          margin-bottom: 8px;
          margin-right: 2px;
          margin-left: 2px;
          transition: all 0.3s ease;
          font-weight: 700;
      }

      #window {
          background-color: transparent;
          box-shadow: none;
      }

      window#waybar {
          background-color: rgba(0, 0, 0, 0.2);
          border-radius: 17px;
      }

      window * {
          background-color: transparent;
          border-radius: 0px;
      }

      #workspaces button label {
          color: #b4befe;
      }

      #workspaces button.active label {
          color: #1e1e2e;
          font-weight: bolder;
      }

      #workspaces button:hover {
          box-shadow: #b4befe 0 0 0 1.5px;
          background-color: #1e1e2e;
          min-width: 50px;
      }

      #workspaces {
          background-color: transparent;
          border-radius: 17px;
          padding: 5 0px;
          margin-top: 3px;
          margin-bottom: 3px;
      }

      #workspaces button {
          background-color: #1e1e2e;
          border-radius: 12px;
          margin-left: 10px;

          transition: all 0.3s ease;
      }

      #workspaces button.visible {
          box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
          background-color: #f2cdcd;
          background-size: 400% 400%;
          transition: all 0.3s ease;
          background: linear-gradient(
          58deg,
          #cba6f7,
          #cba6f7,
          #cba6f7,
          #89b4fa,
          #89b4fa,
          #cba6f7,
          #f38ba8
          );
          background-size: 300% 300%;
          animation: colored-gradient 20s ease infinite;
      }

      #workspaces button.active {
          min-width: 50px;
          box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
          background-color: #f2cdcd;
          background-size: 400% 400%;
          transition: all 0.3s ease;
          background: linear-gradient(
          58deg,
          #cba6f7,
          #cba6f7,
          #cba6f7,
          #89b4fa,
          #89b4fa,
          #cba6f7,
          #f38ba8
          );
          background-size: 300% 300%;
          animation: colored-gradient 20s ease infinite;
      }

      @keyframes colored-gradient {
          0% {
          background-position: 71% 0%;
          }
          50% {
          background-position: 30% 100%;
          }
          100% {
          background-position: 71% 0%;
          }
      }

      #custom-power-menu {
          margin-right: 10px;
          padding-left: 12px;
          padding-right: 15px;
          padding-top: 3px;
      }

      #custom-spotify {
          margin-left: 5px;
          padding-left: 15px;
          padding-right: 15px;
          padding-top: 3px;
          color: #b4befe;
          background-color: #1e1e2e;
          transition: all 0.3s ease;
      }

      #custom-spotify.playing {
          color: rgb(180, 190, 254);
          background: rgba(30, 30, 46, 0.6);
          background: linear-gradient(
          90deg,
          #313244,
          #1e1e2e,
          #1e1e2e,
          #1e1e2e,
          #1e1e2e,
          #313244
          );
          background-size: 400% 100%;
          animation: grey-gradient 3s linear infinite;
          transition: all 0.3s ease;
      }

      @keyframes grey-gradient {
          0% {
          background-position: 100% 50%;
          }
          100% {
          background-position: -33% 50%;
          }
      }

      #tray menu {
          background-color: #1e1e2e;
          opacity: 0.8;
      }

      #pulseaudio.muted {
          color: #f38ba8;
          padding-right: 16px;
      }

      #custom-notification.collapsed,
      #custom-notification.waiting_done {
          min-width: 12px;
          padding-right: 17px;
      }

      #custom-notification.waiting_start,
      #custom-notification.expanded {
          background-color: transparent;
          background: linear-gradient(
          90deg,
          #313244,
          #1e1e2e,
          #1e1e2e,
          #1e1e2e,
          #1e1e2e,
          #313244
          );
          background-size: 400% 100%;
          animation: grey-gradient 3s linear infinite;
          min-width: 500px;
          border-radius: 17px;
      }
    '';
  };
}
