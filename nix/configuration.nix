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
    ../modules/steam.nix
    ../modules/audio.nix
    ../modules/utilities.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

  # sops.secrets.git_sshkey = {};

  hardware.i2c.enable = true;

  boot = {
    supportedFilesystems = ["ntfs"];
    kernelModules = ["i2c-dev"];
    kernelPackages = pkgs.linuxPackages_6_8;
    extraModprobeConfig = ''
      options kvm_intel nested=1
      options kvm_intel emulate_invalid_guest_state=0
      options kvm ignore_msrs=1
    '';
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
      grub2-theme = {
        enable = true;
        theme = "whitesur";
        screen = "2k";
        footer = true;
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
    # pam.services.swaylock = {};
  };

  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
    };

    # greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       command = "Hyprland";
    #       user = "${user}";
    #     };
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

      # windowManager.xmonad = {
      #   enable = true;
      #   enableContribAndExtras = true;
      #   config = builtins.readFile ../xmonad/xmonad.hs;
      # };

      # windowManager.awesome = {
      #   enable = true;
      #   package = pkgs.awesome.overrideAttrs (oldAttrs: rec {
      #     version = "8b1f8958b46b3e75618bc822d512bb4d449a89aa";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "awesomewm";
      #       repo = "awesome";
      #       rev = version;
      #       hash = "sha256-ZGZ53IWfQfNU8q/hKexFpb/2mJyqtK5M9t9HrXoEJCg=";
      #     };
      #     patches = [];
      #     postPatch = ''
      #       patchShebangs tests/examples/_postprocess.lua
      #     '';
      #   });
      # };
    };

    # udev.extraRules = ''
    #   KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="uaccess" ACTION=="add" RUN+="${pkgs.headsetcontrol}/bin/headsetcontrol -l 0"
    # '';

    dbus.enable = true;
    openssh = {
      enable = true;
      # allowSFTP = true;
    };
    gvfs.enable = true;
  };

  programs = {
    # weylus = {
    #   enable = true;
    #   openFirewall = true;
    #   users = ["${user}"];
    # };

    # hyprland = {
    #   enable = true;
    #   package = hyprland.packages.${pkgs.system}.hyprland;
    #   portalPackage = hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    # };

    zsh.enable = true;
    dconf.enable = true;

    nh = {
      enable = true;
      flake = "/home/${user}/.flake";
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
      "display-brightness" = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 17:30:00";
          Persistent = true;
        };
      };
    };
    services = {
      NetworkManager-wait-online.enable = lib.mkForce false;
      "display-brightness" = {
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
    # user.services.headsetlights = {
    #   description = "headsetlights";
    #   wantedBy = ["graphical-session.target"];
    #   wants = ["graphical-session.target"];
    #   after = ["graphical-session.target"];
    #   serviceConfig = {
    #     Type = "simple";
    #     ExecStart = "/etc/profiles/per-user/allusive/bin/lights";
    #     Restart = "on-failure";
    #     RestartSec = 1;
    #     TimeoutStopSec = 10;
    #   };
    # };
  };

  qt = {
    enable = true;
    style = "adwaita-dark";
    platformTheme = "gtk2";
  };

  virtualisation = {
    virtualbox.host.enable = true;
    docker.enable = true;
    libvirtd.enable = true;
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "vboxusers" "docker" "libvirtd"];
    home = "/home/${user}";
    description = "Jasper C";
    shell = pkgs.zsh;
  };

  fonts.fontDir.enable = true;

  environment = {
    sessionVariables = {
      NNN_TRASH = 1;
      NNN_FIFO = "/tmp/nnn.fifo";
      __GL_SYNC_DISPLAY_DEVICE = "DP-2";
    };

    systemPackages = with pkgs; [
      vim
      wget
      sassc
      pkg-config
      zip
      unzip
      ripgrep
      usbutils
    ];
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        # hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };
  };

  system.stateVersion = "${version}";
}
