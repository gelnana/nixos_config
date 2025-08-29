{ pkgs, ... }:

{
  imports = [
    ../../home/core.nix
    ../../home/programs
    ../../home/shell

    ../../home/desktop/plasma
    ../../home/desktop/hypr
  ];
    # Enable programs
  programs.git = {
    userName = "gelnana";
    userEmail = "chloe@semios.is";
  };
  stylix.targets.neovim.enable = true;


}
