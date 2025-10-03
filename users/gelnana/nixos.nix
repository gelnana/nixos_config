{ config, lib, pkgs, ... }:
{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  # Configure main user with persisted password fallback
  main-user = {
    enable = true;
    userName = "gelnana";
    mutableUsers = false;
  };

}
