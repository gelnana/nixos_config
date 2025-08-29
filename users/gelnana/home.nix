{ pkgs, ... }:

{
  imports = [
    ../../home/core.nix
    ../../home/programs
    ../../home/shell
  ];
    # Enable programs
  programs.git = {
    userName = "gelnana";
    userEmail = "chloe@semios.is";
  };
  stylix.targets.neovim.enable = true;


}
