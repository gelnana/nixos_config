{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    kwin-effects-forceblur = {
      url = "github:taj-ny/kwin-effects-forceblur";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kwin-effects-kinetic = {
      url = "github:gurrgur/kwin-effects-kinetic";
      flake = false;
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };


    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-25.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "hyprland";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";
    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";

    tidalcycles.url = "github:mitchmindtree/tidalcycles.nix"; 
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    home-manager,
    apple-fonts,
    hyprland,
    ...
  }@inputs: {
    nixosConfigurations = {
      desktop = let
        username = "gelnana";
        specialArgs = {inherit username inputs;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/desktop
            ./users/${username}/nixos.nix
            stylix.nixosModules.stylix
            inputs.catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;

              home-manager.backupFileExtension = null;
            }
          ];
        };
      laptop = let
        username = "gelnana";
        specialArgs = {inherit username inputs;};
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";

          modules = [
            ./hosts/laptop
            ./users/${username}/nixos.nix
            stylix.nixosModules.stylix
            inputs.catppuccin.nixosModules.catppuccin
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = inputs // specialArgs;
              home-manager.users.${username} = import ./users/${username}/home.nix;

              home-manager.backupFileExtension = null;
            }
          ];
        };
    };
  };
}
