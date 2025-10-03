{ config, pkgs, ... }:

{
  imports = [
    ./editor
  ]
  ++ [
    ./common/archives.nix
    ./common/communications.nix
    ./common/downloads.nix
    ./common/organization.nix
  ]
  ++ [
    ./dev/git.nix
    ./dev/cloud.nix
    ./dev/utils.nix
  ]
  ++ [
    ./creative/video.nix
    ./creative/art.nix
    ./creative/blender.nix
    ./creative/reaper.nix
  ]
  ++ [
    ./games/launchers.nix
    ./games/modding.nix
    ./games/utilities.nix
  ]
  ++ [
    ./web/firefox.nix
    ./xdg.nix
    ./media.nix
    ./impermanence.nix
  ];
}
