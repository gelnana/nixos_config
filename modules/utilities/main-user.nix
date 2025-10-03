{ lib, config, pkgs, username ? "mainuser", ... }:
let
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
    hashedPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to file containing hashed password";
    };
    initialPassword = lib.mkOption {
      type = lib.types.str;
      default = "changeme";
      description = "Initial password";
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
      description = cfg.userName;
      shell = cfg.shell;
      extraGroups = cfg.extraGroups;
    } // (if cfg.hashedPasswordFile != null
          then { hashedPasswordFile = cfg.hashedPasswordFile; }
          else { initialPassword = cfg.initialPassword; });
    security.sudo.enable = cfg.enableSudo;
    environment.shells = [ cfg.shell ];
  };
}
