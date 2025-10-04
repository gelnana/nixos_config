{ lib, config, pkgs, username ? "gelnana", ... }:
let
  sopsSecrets = if lib.hasAttr "sops" config && lib.hasAttr "secrets" config.sops
                then config.sops.secrets else {};
in
{
  options = {
    main-user = {
      enable = lib.mkEnableOption "main-user module";
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
        default = true;
        description = "Whether to allow mutable users";
      };
      enableSops = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable SOPS for password management";
      };
    };
  };

  config = lib.mkIf config.main-user.enable (let
    cfg = config.main-user;
    hasSops = cfg.enableSops && lib.hasAttr (cfg.userName + "-password") sopsSecrets;
  in {
    users.mutableUsers = cfg.mutableUsers;

    users.users.${cfg.userName} = lib.mkMerge [
      {
        isNormalUser = true;
        createHome   = true;
        home         = "/home/${cfg.userName}";
        description  = "${cfg.userName}";
        shell        = cfg.shell;
        extraGroups  = cfg.extraGroups;
      }

      (lib.mkIf hasSops {
        hashedPasswordFile = sopsSecrets."${cfg.userName}-password".path;
      })

      (lib.mkIf (!hasSops) {
        initialPassword = cfg.initialPassword;
      })
    ];

    security.sudo.enable = cfg.enableSudo;
  });
}
