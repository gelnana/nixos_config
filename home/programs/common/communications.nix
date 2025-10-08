{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
    programs.nixcord = {
      enable = true;
      vesktop.enable = true;
      dorion.enable = false;
    };
    home.packages = with pkgs; [
    zoom-us
  ];
}
