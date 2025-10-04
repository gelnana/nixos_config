{ lib, config, pkgs, username ? "gelnana", ... }:
{
  options = {
    main-user = {
      enable = lib.mkEnableOption "main‑user module";
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
        description = "Initial password (fallback)";
      };
      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "wheel" "networkmanager" "video" "audio" "input" ];
        description = "Additional groups for the user";
      };
      enableSudo = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable sudo for wheel group";
      };
      mutableUsers = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to allow mutable users";
      };
    };
  };

  config = lib.mkIf config.main-user.enable (let
    cfg = config.main-user;
    hasSops = config.sops.secrets ? "${cfg.userName}-password";
  in {
    users.mutableUsers = cfg.mutableUsers;

    users.users.${cfg.userName} = {
      isNormalUser = true;
      createHome = true;
      home = "/home/${cfg.userName}";
      description = "User ${cfg.userName}";
      shell = cfg.shell;
      extraGroups = cfg.extraGroups;
      hashedPasswordFile = lib.mkIf hasSops
        config.sops.secrets."${cfg.userName}-password".path;
      initialPassword = lib.mkIf (!hasSops) cfg.initialPassword;
    };

    security.sudo.enable = cfg.enableSudo;

    sops.secrets = lib.mkIf hasSops {
      "${cfg.userName}_password".neededForUsers = true;
    };
  });
}
