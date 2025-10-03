{ config, lib, pkgs, username, ... }:
{
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  users = {
    mutableUsers = false;

    users.${username} = {
      isNormalUser = true;
      description = username;
      shell = pkgs.nushell;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
      initialPassword = "password";
      hashedPasswordFile = "/persist/etc/shadow/${username}";
    };

    users.root = {
      initialPassword = "password";
      hashedPasswordFile = "/persist/etc/shadow/root";
    };
  };

}
