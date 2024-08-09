{
  config,
  lib,
  pkgs,
  inputs,
  user,
  # hyprland,
  hostname,
  version,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./modules/steam.nix
    ./modules/audio.nix
    ./modules/utilities.nix
  ];

  hardware.i2c.enable = true;

  boot = {
    kernelModules = ["i2c-dev"];
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_6_8;
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };

  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      auto-optimise-store = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 8000;
          to = 8090;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 8000;
          to = 8090;
        }
      ];
    };
    hostName = "${hostname}";
    networkmanager = {
      enable = true;
    };
  };

  time.timeZone = "Australia/Sydney";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  security = {
    polkit.enable = true;
  };

  services = {
    # ollama = {
    #   enable = true;
    #   acceleration = "cuda";
    #   environmentVariables = {
    #     OLLAMA_LLM_LIBRARY = "cuda";
    #     LD_LIBRARY_PATH = "run/opengl-driver/lib";
    #   };
    # };

    xserver = {
      enable = true;
      layout = "us";
      xautolock = {
        enable = true;
        time = 15;
        locker = ''
          ${pkgs.betterlockscreen}/bin/betterlockscreen -l
        '';
      };
      displayManager = {
        session = [
          {
            manage = "desktop";
            name = "herbstluft";
            start = ''
              ${pkgs.herbstluftwm}/bin/herbstluftwm --locked &
              waitPID=$!
            '';
          }
        ];
        defaultSession = "herbstluft";
        sessionCommands = ''
          xrandr --output DP-2 --mode 2560x1440 --rate 144.00 --primary --output DP-0 --mode 1920x1080 --rate 75.00 --right-of DP-2 --rotate left --output HDMI-1 --mode 1920x1080 --rate 120.00 --left-of DP-2 --rotate right
        '';
      };

      windowManager.herbstluftwm = {
        enable = true;
      };
    };

    dbus.enable = true;
    openssh = {
      enable = true;
    };
    gvfs.enable = true;
  };

  programs = {
    zsh.enable = true;
    dconf.enable = true;

    nh = {
      enable = true;
      flake = "/home/${user}/.files";
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        curl
        dbus
        expat
        fontconfig
        freetype
        fuse3
        gdk-pixbuf
        glib
        gtk3
        icu
        wayland
        libGL
        libGLU
        glfw
        glew
        libappindicator-gtk3
        libdrm
        libglvnd
        libnotify
        libpulseaudio
        libunwind
        libusb1
        libuuid
        libxkbcommon
        libxml2
        mesa
        nspr
        nss
        openssl
        pango
        pipewire
        stdenv.cc.cc
        systemd
        vulkan-loader
        xorg.libX11
        xorg.libXScrnSaver
        xorg.libXcomposite
        xorg.libXcursor
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXi
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libxcb
        xorg.libxkbfile
        xorg.libxshmfence
        zlib
      ];
    };
  };

  systemd = {
    timers = {
      "display-brightness-down" = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 17:30:00";
          Persistent = true;
        };
      };
      "headset-lights" = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "1m";
        };
      };
    };
    services = {
      NetworkManager-wait-online.enable = lib.mkForce false;
      "headset-lights" = {
        script = ''
          #!/usr/bin/env bash
          while true; do
            LAST_BATTERY_LEVEL="$BATTERY_LEVEL"
            BATTERY_LEVEL=$(${pkgs.headsetcontrol}/bin/headsetcontrol -cb 2>/dev/null)

            if [ -z "$LAST_BATTERY_LEVEL" ] && [ -n "$BATTERY_LEVEL" ]; then
              # Headset connected
              ${pkgs.headsetcontrol}/bin/headsetcontrol -l 0
            fi
            sleep 2s
          done
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
      "display-brightness-up" = {
        script = ''
          ${pkgs.ddcutil}/bin/ddcutil --model VG258 setvcp 10 50
          ${pkgs.ddcutil}/bin/ddcutil --model VX2758-SERIES setvcp 10 80
          ${pkgs.ddcutil}/bin/ddcutil --model 'DELL S2421HS' setvcp 10 70
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
      "display-brightness-down" = {
        script = ''
          ${pkgs.ddcutil}/bin/ddcutil --model VG258 setvcp 10 20
          ${pkgs.ddcutil}/bin/ddcutil --model VX2758-SERIES setvcp 10 50
          ${pkgs.ddcutil}/bin/ddcutil --model 'DELL S2421HS' setvcp 10 30
        '';
        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
  };

  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
    docker.enableNvidia = true;
    oci-containers = {
      backend = "docker";
      containers = {
        ollama = {
          autoStart = true;
          image = "ollama/ollama";
          extraOptions = ["--gpus" "all"];
          ports = ["11434:11434"];
          volumes = ["ollama:/root/.ollama"];
        };
      };
    };
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "vboxusers" "docker"];
    home = "/home/${user}";
    description = "Jasper C";
    shell = pkgs.zsh;
  };

  fonts.fontDir.enable = true;

  environment = {
    sessionVariables = {
      __GL_SYNC_DISPLAY_DEVICE = "DP-2";
      EDITOR = "nvim";
    };

    systemPackages = with pkgs; [
      stow
      vim
      wget
      sassc
      pkg-config
      zip
      unzip
      ripgrep
      usbutils
      distrobox
    ];
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };

  system.stateVersion = "${version}";
}
