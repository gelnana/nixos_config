{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    catppuccin.url = "github:catppuccin/nix";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    musnix.url = "github:musnix/musnix";

    stylix.url = "github:nix-community/stylix";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nix-gaming.url = "github:fufexan/nix-gaming";

    umu.url = "github:Open-Wine-Components/umu-launcher?dir=packaging/nix";

    tidalcycles.url = "github:mitchmindtree/tidalcycles.nix";

    alejandra = {
      url = "github:kamadorueda/alejandra/4.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    sops-nix = {
        url = "github:Mic92/sops-nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
   
    secrets = {
      url = "git+ssh://git@github.com/gelnana/secrets.git?shallow=1";
      flake = false;
    };
   
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      username = "gelnana";
      system = "x86_64-linux";

      # specialArgs shared between NixOS + Home Manager
      specialArgs = { inherit username inputs; };

      allModules = [
        # External modules
        inputs.stylix.nixosModules.stylix
        inputs.catppuccin.nixosModules.catppuccin
        inputs.musnix.nixosModules.musnix
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops

        # Core system
        ./modules/utilities/system.nix
        ./modules/utilities/main-user.nix

        # Roles
        ./modules/roles/audio.nix
        ./modules/roles/gaming.nix
        ./modules/roles/dev.nix
        ./modules/roles/impermanence.nix

        # Hardware
        ./modules/hardware/nvidia.nix
        ./modules/hardware/bluetooth.nix
        ./modules/hardware/laptop.nix
        ./modules/hardware/zfs.nix
        
        # Services
        ./modules/services/ssh.nix
        ./modules/services/soulseek.nix
        ./modules/services/plasma.nix

        # Themes
        ./modules/utilities/catppuccin.nix
        ./modules/utilities/stylix.nix
      ];

      homeManagerModule = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = inputs // specialArgs;
          users.${username} = import ./users/${username}/home.nix;
          backupFileExtension = null;
        };
      };

      mkSystem = hostname:
        nixpkgs.lib.nixosSystem {
          inherit system specialArgs;
          modules =
            allModules
            ++ (if hostname == "laptop"
                  then [ inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia ]
                  else [])
            ++ [
              ./hosts/${hostname}
              ./users/${username}/nixos.nix
              home-manager.nixosModules.home-manager
              homeManagerModule
            ];
        };
    in {
      nixosConfigurations = {
        desktop = mkSystem "desktop";
        laptop = mkSystem "laptop";
        live = (import ./hosts/live {
          inherit inputs system;
          lib = nixpkgs.lib;
        }).gnome-iso;
      };
      formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
    };
}
