{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    grub2-themes = {
      url = "github:vinceliuice/grub2-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland"; # IMPORTANT
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify
    # spicetify-nix = {
    #  url = "github:the-argus/spicetify-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };

    # aagl = {
    #  url = "github:ezKEa/aagl-gtk-on-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    # };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    grub2-themes,
    hyprland,
    hyprgrass,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    version = "24.05";
    user = "allusive";
    hostname = "nixos";
    wayland = true;
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit user hyprland hostname version inputs;};
        modules = [
          ./nix/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit user inputs system hyprland hyprgrass version pkgs;};
            home-manager.users.${user} = {
              imports = [
                ./home/home.nix
              ];
            };
          }
          grub2-themes.nixosModules.default
          # {
          #   nix.settings = aagl.nixConfig;
          #   imports = [ aagl.nixosModules.default ];
          #   programs.anime-game-launcher.enable = true;
          # }
        ];
      };
    };
  };
}
