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
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

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
      auto-optimise-store = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking = {
    firewall = {
      enable = false;
      # allowedTCPPortRanges = [
      #   { from = 8000; to = 8010; }
      # ];
      # allowedUDPPortRanges = [
      #   { from = 8000; to = 8010; }
      # ];
    };
    hostName = "${hostname}";
    networkmanager ={
      enable = true;
      dns = "none";
    };
    nameservers = [ "1.1.1.1" ];
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

    ollama = {
      enable = true;
      acceleration = "cuda";
    };

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
      '';
    };
    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    # blueman.enable = true;

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
    openssh = {
      enable = true;
      allowSFTP = true;
    };
    gvfs.enable = true;
  };

  programs = {
    weylus = {
      enable = true;
      openFirewall = true;
      users = [ "allusive" ];
    };
    
    zsh.enable = true;
    direnv.enable = true;
    dconf.enable = true;
    
    nh = {
      enable = true;
      flake = "/home/${user}/.flake";
    };

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
    user.services.headsetlights = {
      description = "headsetlights";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.headsetcontrol}/bin/headsetcontrol -l 0";
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
    # virtualbox.host.enableExtensionPack = true;
    docker.enable = true;
    docker.enableNvidia = true;
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
