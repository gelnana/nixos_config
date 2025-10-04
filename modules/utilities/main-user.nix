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
      hashedPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = "/etc/shadow/${username}";
        description = "Path to file containing hashed password";
      };
      initialPassword = lib.mkOption {
        type = lib.types.str;
        default = "changeme";
        description = "Initial password (fallback if hashedPasswordFile doesn't exist)";
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
  in
    {
      users.mutableUsers = cfg.mutableUsers;

      users.users = {
        root = {
          isNormalUser = false;
          initialPassword = cfg.initialPassword;
          hashedPasswordFile = "/etc/shadow/root";
        };

        ${cfg.userName} = {
          isNormalUser = true;
          createHome = true;
          home = "/home/${cfg.userName}";
          description = "User ${cfg.userName}";
          shell = cfg.shell;
          extraGroups = cfg.extraGroups;
          initialPassword = cfg.initialPassword;
          hashedPasswordFile = cfg.hashedPasswordFile;
        };
      };

      security.sudo.enable = cfg.enableSudo;
    }
  );
}
