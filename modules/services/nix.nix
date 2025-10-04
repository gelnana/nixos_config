{
  config,
  host,
  lib,
  pkgs,
  self,
  username,
  ...
}:
{
  # execute shebangs that assume hardcoded shell paths
  services.envfs.enable = true;

  # run unpatched binaries on nixos
  programs.nix-ld.enable = true;

  # setup "appimage-run" interpreter to run appimages directly wihout issues
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  environment = {
    systemPackages =
      # for nixlang / nixpkgs
      with pkgs; [
        nil
        nixd
        nix-init
        nix-update
        nixfmt-rfc-style
        nixpkgs-fmt
        nixpkgs-review
      ];
  };

  nix = {
    # channel.enable = false;
    gc = {
      # Automatic garbage collection
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.latest;
    registry = {
      nixpkgs-master = {
        from = {
          type = "indirect";
          id = "nixpkgs-master";
        };
        to = {
          type = "github";
          owner = "NixOS";
          repo = "nixpkgs";
        };
      };
    };
    settings = {
      auto-optimise-store = true; # Optimise symlinks
      # re-evaluate on every rebuild instead of "cached failure of attribute" error
      eval-cache = false;
      warn-dirty = false;
      # removes ~/.nix-profile and ~/.nix-defexpr
      use-xdg-base-directories = true;

      # use flakes
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
      ];

      trusted-users = [ username ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      ];
    };
  };
}
