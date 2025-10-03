{ config, lib, pkgs, ... }:
{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  main-user = {
    enable = true;
    userName = "gelnana";
  };

  users.users.gelnana = {
    hashedPasswordFile = config.sops.secrets.gelnana-password.path;
    initialPassword = lib.mkForce null;
  };
}
