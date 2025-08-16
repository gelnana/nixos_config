{ config, pkgs, ... }:
{

  programs= {
    kitty = {
      enable = true;

      settings = {
        window_padding_width = 5;
        copy_on_select = "clipboard";
      };
    };
  };
  }
