{
  inputs,
  lib,
  system ? "x86_64-linux",
  ...
}:
let
  repo_url = "https://github.com/gelnana/nixos-config";

  mkIso =
    nixpkgs: isoPath:
    lib.nixosSystem {
      inherit system;
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/${isoPath}.nix"
        (
          { pkgs, ... }:
          {
            environment = {
              systemPackages =
                [
                  (pkgs.writeShellApplication {
                    name = "gelnana-install";
                    runtimeInputs = [ pkgs.curl ];
                    text = "sh <(curl -L ${repo_url}/raw/refs/heads/main/install.sh)";
                  })
                ]
                ++ (with pkgs; [
                  btop
                  git
                  eza
                  yazi
                  helix
                ]);
              shellAliases = {
                eza = "eza '--icons' '--group-directories-first' '--header' '--octal-permissions' '--hyperlink'";
                ls = "eza";
                ll = "eza -l";
                la = "eza -a";
                lla = "eza -la";
                t = "eza -la --git-ignore --icons --tree --hyperlink --level 3";
                tree = "eza -la --git-ignore --icons --tree --hyperlink --level 3";
                zz = "zellij";
              };
            };

            programs = {
              nano.enable = false;
            };

            nix.settings = {
              experimental-features = [
                "nix-command"
                "flakes"
              ];
              substituters = [
                "https://hyprland.cachix.org"
                "https://nix-community.cachix.org"
                "https://devenv.cachix.org"
              ];
              trusted-public-keys = [
                "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
              ];
            };
          }
        )
      ];
    };
in
{
  gnome-iso = mkIso inputs.nixpkgs "installation-cd-graphical-calamares-gnome";
  kde-iso = mkIso inputs.nixpkgs "installation-cd-graphical-calamares-plasma6";
  minimal-iso = mkIso inputs.nixpkgs "installation-cd-minimal";
}
