{
  description = "My NixOS config";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs: {
    nixosConfigurations.louis-desktop-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/desktop

        # make home-manager as a module of nixos so that home-manager
        # configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.louist = import ./home/home.nix;

          # Allow unstable packages to be accessible through `pkgs.unstable`
          nixpkgs.overlays = [
            (final: _prev: {
              unstable = import nixpkgs-unstable {
                system = final.system;
                config.allowUnfree = true;
              };
            })
          ];
        }
      ];
    };
  };
}
