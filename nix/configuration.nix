{
  config,
  lib,
  pkgs,
  inputs,
  user,
  hyprland,
  hostname,
  version,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
  ];

  boot = {
    supportedFilesystems = [ "ntfs" ];
    # extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    # extraModprobeConfig = ''
    #  options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    # '';
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_6_1.override {
    #   argsOverride = rec {
    #     src = pkgs.fetchurl {
    #         url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    #         hash = "sha256-bNGUEDMME+xMGP0oqD0+QPwSoVKBX7fD4bB2QykJOlY=";
    #     };
    #     version = "6.1.75";
    #     modDirVersion = "6.1.75";
    #   };
    # });
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
        theme = "vimix";
        screen = "2k";
        footer = true;
      };
    };
  };

  nix = {
    settings = {
      # substituters = [ "https://ezkea.cachix.org" ];
      # trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
      experimental-features = [ "nix-command" "flakes" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking = {
    hostName = "${hostname}";
    networkmanager ={
      enable = true;
      # dns = "none";
    };
    # nameservers = [ "1.1.1.1" ];
  };

  time.timeZone = "Australia/Sydney";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    pulseaudio.enable = lib.mkForce false;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  sound.enable = lib.mkForce false; # disable alsa

  services = {
    greetd = {
      enable = true;
      settings = {
        initial_session = {
          command = "Hyprland";
          user = "${user}";
        };
        default_session = {
	        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --greeting 'Welcome' --asterisks --remember --remember-user-session --time -cmd Hyprland";
	        user = "greeter";
	      };
      };
    };
    mpd = {
      enable = true;
      musicDirectory = "/home/${user}/Music";
      user = "${user}";
      # extraConfig = ''
      #   audio_output {
      #     type "pipewire"
      #     name "Pipewire Output"
      #   }
      # '';
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Pipewire Output"
          buffer_time "100000"
        }

        audio_output {
          type "fifo"
          name "Visualizer"
          path "/tmp/mpd.fifo"
          format "44100:16:2"
        }
      '';
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      # windowManager.awesome = {
      #   enable = true;
      #   package = pkgs.awesome.overrideAttrs (old: {
      #     version = "75758b07f3c3c326d43ac682896dbcf18fac4bd7";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "awesomeWM";
      #       repo = "awesome";
      #       rev = version;
      #       hash = "sha256-pT9gCia+Cj3huTbDcXf/O6+EL6Bw4PlvL00IJ1gT+OY=";
      #     };
      #     patches = [];
      #     postPatch = ''
      #       patchShebangs tests/examples/_postprocess.lua
      #     '';
      #   });
      # };
    };

    blueman.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="uaccess" ACTION=="add" RUN+="${pkgs.headsetcontrol}/bin/headsetcontrol -l 0"
    '';

    printing = {
      enable = true;
      drivers = [ pkgs.cnijfilter2 ];
    };
    avahi.enable = true;

    dbus.enable = true;
    openssh.enable = true;
    gvfs.enable = true;
  };

  programs = {
    zsh.enable = true;
    direnv.enable = true;
    dconf.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        fuse3
        openssl
        curl
        libxkbcommon #
        libudev-zero #
        libappindicator-gtk3
        libdrm
        libglvnd
        libusb1
        libuuid
        libxml2
        libva
        libinput #
        mesa #
        fontconfig #
        freetype #
      ];
    };
  };

  systemd = {
    services = {
      mpd.environment = {
        XDG_RUNTIME_DIR = "/run/user/1000";
      };
      NetworkManager-wait-online.enable = lib.mkForce false;
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
    style = "adwaita-dark";
    platformTheme = "gtk2";
  };

  virtualisation = {
    virtualbox.host.enable = true;
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
    systemPackages = with pkgs; [
      vim
      wget
      sassc
      pkg-config
      zip
      unzip
      ripgrep
      sane-backends
      mpdris2
      usbutils
    ];
  };
  xdg = {
    portal = {
      enable = true;
      # wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };
  };

  system.stateVersion = "${version}";
}
