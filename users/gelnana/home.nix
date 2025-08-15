{ pkgs, ... }:

{
  imports = [
    ../../home/core.nix

    ../../home/programs
    ../../home/shell
    ../../home/styling/stylix.nix
  ];
    # Enable programs
  programs.git = {
    userName = "gelnana";
    userEmail = "chloe@semios.is";
  };


}
