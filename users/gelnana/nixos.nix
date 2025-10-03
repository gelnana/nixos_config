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

  # Configure root user with same fallback strategy
  users.users.root = {
    initialPassword = "changeme";  # Emergency fallback
    hashedPasswordFile = "/persist/etc/shadow/root";  # Primary fallback
  };
}
