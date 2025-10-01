{ pkgs, ... }:

{
  home.packages = with pkgs; [
    xivlauncher
    prismlauncher
    heroic
    parallel-launcher
    lutris
    umu-launcher
    nexusmods-app-unfree
    limo
    protontricks
  ];
}
