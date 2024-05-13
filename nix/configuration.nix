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
    ../modules/steam.nix
    ../modules/audio.nix
    ../modules/utilities.nix
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/${user}/.config/sops/age/keys.txt";

  # sops.secrets.git_sshkey = {};

  boot = {
    supportedFilesystems = [ "ntfs" ];
    kernelPackages = pkgs.linuxPackages_latest;
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
      experimental-features = [ "nix-command" "flakes" ];
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
        { from = 8000; to = 8090; }
      ];
      allowedUDPPortRanges = [
        { from = 8000; to = 8090; }
      ];
    };
    hostName = "${hostname}";
    networkmanager ={
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
    pam.services.swaylock = {};
  };

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

    xserver = {
      enable = true;
      xkb.layout = "us";
    };

    # blueman.enable = true;

    udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="0ab5", TAG+="uaccess" ACTION=="add" RUN+="${pkgs.headsetcontrol}/bin/headsetcontrol -l 0"
    '';

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
      users = [ "${user}" ];
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
        xorg.libX11
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
      # mpd.environment = {
      #   XDG_RUNTIME_DIR = "/run/user/1000";
      # };
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
        ExecStart = "/etc/profiles/per-user/allusive/bin/lights";
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
