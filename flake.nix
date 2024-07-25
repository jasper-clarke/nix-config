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

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    version = "24.11";
    user = "allusive";
    hostname = "nixos";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = {
      ${hostname} = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit user hostname version inputs;};
        modules = [
          ./nix/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit user inputs system version pkgs;};
            home-manager.users.${user} = {
              imports = [
                ./nix/home/home.nix
              ];
            };
          }
        ];
      };
    };
  };
}
