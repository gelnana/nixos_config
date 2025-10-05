{
  config,
  lib,
  pkgs,
  ...
}: {
  ##################################################################################################################
  #
  # NixOS Configuration
  #
  ##################################################################################################################

  main-user = {
    enable = true;
    userName = "gel";
  };
    users.users.gel = {
    hashedPasswordFile = config.sops.secrets."gel-password".path;
  };
}
