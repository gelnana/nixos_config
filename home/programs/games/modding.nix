{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Modding tools
    limo
    nexusmods-app-unfree
    protontricks
  ];
}
