{
  description = "Saber Custom Cursor";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    {
      self,
      flake-utils,
      nixpkgs,
      home-manager,
      plasma-manager,
    }:
    let
      pkgs-name = "saber-cursor";
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          ${pkgs-name} = pkgs.callPackage ./package.nix { };
          default = self.packages.${system}.${pkgs-name};
        };
      }
    )
    // {
      homeManagerModules.${pkgs-name} = import ./module.nix;
      homeManagerModules.default = self.homeManagerModules.${pkgs-name};

      # TEST This configuration was made for testing purposes.
      # To test run `nix build .#homeConfigurations.test-dummy.activationPackage`
      homeConfigurations."test-dummy" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          plasma-manager.homeModules.plasma-manager
          self.homeManagerModules.${pkgs-name}
          {
            home = {
              username = "test-user";
              homeDirectory = "/home/test-user";
              stateVersion = "25.05";
            };

            programs.plasma.enable = true;
            programs.saber-cursor.enable = true;
          }
        ];
      };
    };
}
