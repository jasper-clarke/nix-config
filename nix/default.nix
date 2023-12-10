{
  lib,
  inputs,
  system,
  home-manager,
  user,
  version,
  aagl,
  ...
}: {
  nixos = lib.nixosSystem {
    inherit system;
    specialArgs = {inherit user version inputs;};
    modules = [
      ./configuration.nix
      home-manager.nixosModules.home-manager
      {
       nix.settings = aagl.nixConfig;
       imports = [ aagl.nixosModules.default ];
       programs.anime-game-launcher.enable = true;
      }
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {inherit user inputs system version;};
        home-manager.users.${user} = {
          imports = [
            ../home/home.nix
            ../home/terminal.nix
            #../home/spicetify.nix
          ];
        };
      }
    ];
  };
}
