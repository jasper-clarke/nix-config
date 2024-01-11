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
    hostName = "nixos";
    networkmanager ={
      enable = true;
    };
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
      nvidiaSettings = true;
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
      layout = "us";
      displayManager = {
        gdm = {
          enable = true;
        };
        sessionCommands = ''
          sh /home/allusive/.flake/setup/scripts/lightdm.sh
        '';
      };
      videoDrivers = ["nvidia"];
      windowManager.awesome = {
        enable = true;
        package = pkgs.awesome.overrideAttrs (old: {
          version = "1f7ac8f9c7ab9fff7dd93ab4b29514ff3580efcf";
          src = pkgs.fetchFromGitHub {
            owner = "awesomeWM";
            repo = "awesome";
            rev = "1f7ac8f9c7ab9fff7dd93ab4b29514ff3580efcf";
            hash = "sha256-D5CTo4FvGk2U3fkDHf/JL5f/O1779i92UcRpPn+lbpw=";
          };
          patches = [];
          postPatch = ''
            patchShebangs tests/examples/_postprocess.lua
          '';
        });
      };
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
    noisetorch.enable = true;
    zsh.enable = true;
    direnv.enable = true;
    dconf.enable = true;
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
    #guest.enable = true;
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
    # sessionVariables = {
    #   GI_TYPELIB_PATH = "/nix/store/7ah2yapjqvx33as3gqxqkgaica6x8mp7-pango-1.51.0/lib/girepository-1.0:/nix/store/h979i6ql0gzlzk7i0kj7l1nmaijqcn9s-gobject-introspection-wrapped-1.78.1/lib/girepository-1.0:/nix/store/7j1farc84m0pi620frxhrzjrvs8i9ci7-gobject-introspection-1.78.1/lib/girepository-1.0:/nix/store/9v7bs0i8r6x9sg6q64qyhqgzmj1nrbmw-gdk-pixbuf-2.42.10/lib/girepository-1.0:/nix/store/s95lcx7j16z47n43r1m7rik65wigv480-librsvg-2.57.0/lib/girepository-1.0:/nix/store/rnw7n0c8zxhzxzrn8d7kr1xmc95wxqlw-harfbuzz-7.3.0/lib/girepository-1.0:/home/allusive/.config/awesome/typelib";
    # };
    systemPackages = with pkgs; [
      vim
      wget
      gvfs
      sassc
      pkg-config
      zip
      unzip
      polkit_gnome
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
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };

  system.stateVersion = "${version}";
}
