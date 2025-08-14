{ config, pkgs, ... }:
{

  programs= {
    konsole = {
      enable = true;
    };
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "git" "sudo" "pip"
        ];
      };
    };
  };
  }
