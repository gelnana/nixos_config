{
  lib,
  config,
  pkgs,
  username ? "gel",
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
      description = "default shell for the user";
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
      description = "additional groups for the user";
    };

    enableSudo = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "enable sudo for wheel group";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.userName} = {
      isNormalUser = true;
      description = cfg.userName;
      shell = cfg.shell;
      extraGroups = cfg.extraGroups;
    };

    security.sudo.enable = cfg.enableSudo;

    environment.shells = [cfg.shell];
  };
}
