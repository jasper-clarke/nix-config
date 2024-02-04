{
  config,
  lib,
  pkgs,
  inputs,
  user,
  hostname,
  version,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./symlinks.nix
  ];

  boot = {
    supportedFilesystems = [ "ntfs" ];
    #extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    #extraModprobeConfig = ''
    #  options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    #'';
    # kernelPackages = pkgs.linuxPackages_latest;
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
      substituters = [ "https://ezkea.cachix.org" ];
      trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
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
      #dns = "none";
    };
    #nameservers = [ "1.1.1.1" ];
  };

  virtualisation.docker.enable = true;

  time.timeZone = "Australia/Sydney";

  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      nvidiaSettings = false;
    };
    pulseaudio.enable = lib.mkForce false;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  sound.enable = lib.mkForce false; # disable alsa

  services = {
    mpd = {
      enable = true;
      musicDirectory = "/home/${user}/Music";
      user = "${user}";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "Pipewire Output"
        }
      '';
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        # sessionCommands = ''
        #   sh /home/allusive/.flake/setup/scripts/lightdm.sh
        # '';
      };
      videoDrivers = ["nvidia"];
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

    pipewire = {
      enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="uaccess"  ACTION=="add" RUN+="${lib.getExe pkgs.headsetcontrol} -l 0"
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

    hyprland = {
      enable = true;
      xwayland.enable = true;
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

  virtualisation.virtualbox = {
    host.enable = true;
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "vboxusers" "docker"];
    home = "/home/allusive";
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

      #(writers.writePython3Bin "ddg-ff-search" { flakeIgnore = ["E121" "E126" "E201" "E202" "E203" "E226" "E261" "E265" "E266" "E302" "E305" "E501" "E722" "W292"]; } ./scripts/rofi-web-search.py)
    ];
  };
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal
        xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };
  };

  system.stateVersion = "${version}";
}
