{
  nixConfig = {
    extra-substituters = ["https://nix-community.cachix.org"];
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
    nixcord = {
      url = "github:kaylorben/nixcord";
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

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      }
    # impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    username = "gel";
    userVars = import ./users/${username}/variables.nix;
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {allowUnfree = true;};
    };

    lib = import ./lib.nix {
      inherit (nixpkgs) lib;
      inherit pkgs;
      inherit (inputs) home-manager;
    };

    createCommonArgs = system: {
      inherit self inputs nixpkgs lib pkgs system username;
      specialArgs = {inherit self inputs username lib userVars;};
    };

    commonArgs = createCommonArgs system;

    allModules = [
      inputs.stylix.nixosModules.stylix
      inputs.catppuccin.nixosModules.catppuccin
      inputs.nix-index-database.nixosModules.nix-index
      inputs.musnix.nixosModules.musnix
      inputs.sops-nix.nixosModules.sops

      ./modules/services/sops.nix
      ./modules/utilities/system.nix
      ./modules/services/nix.nix
      ./modules/utilities/main-user.nix
      ./modules/hardware/mounts.nix

      ./modules/roles/audio.nix
      ./modules/roles/gaming.nix
      ./modules/services/security.nix
      ./modules/roles/dev.nix

      ./modules/hardware/zfs.nix
      ./modules/hardware/hardware.nix
      ./modules/hardware/bluetooth.nix
      ./modules/hardware/laptop.nix

      ./modules/services/ssh.nix
      ./modules/services/soulseek.nix
      ./modules/services/plasma.nix

      ./modules/utilities/catppuccin.nix
      ./modules/utilities/stylix.nix
    ];

    homeManagerModule = {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = commonArgs.specialArgs;
        users.${username} = import ./users/${username}/home.nix;
        backupFileExtension = null;
      };
    };

    mkSystem = hostname:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = commonArgs.specialArgs;
        modules =
          allModules
          ++ (
            if hostname == "laptop"
            then [inputs.nixos-hardware.nixosModules.dell-xps-15-7590-nvidia]
            else []
          )
          ++ [
            ./hosts/${hostname}
            ./hosts/${hostname}/hardware.nix
            ./users/${username}/nixos.nix
            home-manager.nixosModules.home-manager
            homeManagerModule
          ];
      };
  in {
    nixosConfigurations = {
      desktop = mkSystem "desktop";
      laptop = mkSystem "laptop";
    };

    homeConfigurations = {
      "${username}" = home-manager.lib.homeManagerConfiguration (commonArgs
        // {
          modules = [./users/${username}/home.nix];
        });
    };

    formatter.${commonArgs.system} = nixpkgs.legacyPackages.${commonArgs.system}.alejandra;
  };
}
