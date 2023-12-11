{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spicetify
    #spicetify-nix = {
    #  url = "github:the-argus/spicetify-nix";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};

    aagl = {
     url = "github:ezKEa/aagl-gtk-on-nix";
     inputs.nixpkgs.follows = "nixpkgs";
    };

  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    #spicetify-nix,
    aagl,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    version = "23.11";
    user = "allusive";
    hostname = "nixos";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in {
    nixosConfigurations = (
      import ./nix {
        inherit (nixpkgs) lib;
        inherit inputs user hostname system version home-manager aagl;
      }
    );
  };
}
