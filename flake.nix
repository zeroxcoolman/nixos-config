{
  description = "flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    st-src.url = "path:/home/ehsab/.config/builds/st";
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      st-src,
      ...
    }@inputs:
    {
      nixosConfigurations.crawlere30 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit st-src; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager

          {
            home-manager.useUserPackages = true;
            home-manager.useGlobalPkgs = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.ehsab = import ./home.nix;
          }
        ];
      };
    };
}
