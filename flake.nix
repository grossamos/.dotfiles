{
  description = "nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jail-nix.url = "sourcehut:~alexdavid/jail.nix";
    kagi.url = "github:Microck/kagi-cli";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    jail-nix,
    kagi,
    ...
  }: let
    user = "amos";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs self user;};
      modules = [
        ./system/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.amos = import ./home-manager/home.nix;
          home-manager.extraSpecialArgs = {
            inherit inputs self user kagi jail-nix;
          };
        }
      ];
    };
  };
}
