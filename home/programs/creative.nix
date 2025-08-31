{ lib, pkgs, ... }:
let
  wine = pkgs.wineWowPackages.yabridge;
in
{
  home.packages = with pkgs; [
    # audio
    musescore
    reaper
    (pkgs.yabridge.override { inherit wine; })
    (pkgs.yabridgectl.override { inherit wine; })

    # art
    krita
    gimp
    inkscape
    clementine
    libreoffice-fresh

    # video
    davinci-resolve
  ];
}
