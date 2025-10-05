{
  lib,
  config,
  pkgs,
  username ? "gelnana",
  ...
}: let
  cfg = config.main-user;
in {
  options.main-user = {
    enable = lib.mkEnableOption "main user module";

    userName = lib.mkOption {
      type = lib.types.str;
      default = username;
      description = "Primary username";
    };

    shell = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nushell;
      description = "Default shell for the user";
    };

    initialPassword = lib.mkOption {
      type = lib.types.str;
      default = "changeme";
      description = "Initial password (change after first login!)";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "input"
      ];
      description = "Additional groups for the user";
    };

    enableSudo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable sudo for wheel group";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      initialPassword = cfg.initialPassword;
      description = cfg.userName;
      shell = cfg.shell;
      extraGroups = cfg.extraGroups;
    };

    security.sudo.enable = cfg.enableSudo;

    environment.shells = [cfg.shell];
  };
}
