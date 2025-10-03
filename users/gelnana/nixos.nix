{ config, ... }:
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

  # Override the password with sops
  users.users.gelnana = {
    hashedPasswordFile = config.sops.secrets.gelnana-password.path;
    initialPassword = lib.mkForce null;  # Remove the initial password
  };
}
