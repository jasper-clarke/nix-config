{
  config,
  lib,
  pkgs,
  inputs,
  user,
  version,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    supportedFilesystems = [ "ntfs" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        # theme = pkgs.stdenv.mkDerivation {
        #   pname = "distro-grub-themes";
        #   version = "3.1";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "AdisonCavani";
        #     repo = "distro-grub-themes";
        #     rev = "v3.1";
        #     hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
        #   };
        #   installPhase = "cp -r customize/nixos $out";
        # };
      };
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      substituters = [ "https://ezkea.cachix.org" ];
      trusted-public-keys = [ "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI=" ];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
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
    teamviewer.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      autorun = true;
      displayManager = {
        #startx.enable = true;
        defaultSession = "none+xmonad";
        lightdm = {
          enable = true;
          greeters.slick.enable = true;
        };
        sessionCommands = ''
          sh /home/allusive/.flake/setup/scripts/lightdm.sh
        '';
      };
      videoDrivers = ["nvidia"];
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
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
    zsh.enable = true;
    direnv.enable = true;
    dconf.enable = true;
    noisetorch.enable = true;
  };

  systemd = {
    services.NetworkManager-wait-online.enable = lib.mkForce false;
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

  virtualisation.virtualbox.host.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "vboxusers" "docker"];
    home = "/home/allusive";
    description = "Allusive";
    shell = pkgs.zsh;
  };

  fonts.fontDir.enable = true;

  environment = {
    #etc = {
    #  "openal/alsoft.conf".text = "drivers=pulse\n";
    #};
    systemPackages = with pkgs; [
      vim
      wget
      git
      gvfs
      sassc
      pkg-config
      zip
      unzip
      polkit_gnome
      ripgrep
      sane-backends
      pavucontrol
      cloudflared

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
