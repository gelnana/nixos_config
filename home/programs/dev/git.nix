{ lib, config, pkgs, ... }:
let
  cfg = config.custom.programs.git;
in {
  options.custom.programs.git = {
    enable = lib.mkEnableOption "Git version control";

    userName = lib.mkOption {
      type = lib.types.str;
      default = "gelnana";
      description = "Git user name";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      default = "your.email@example.com";
      description = "Git user email";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.userName;
      userEmail = cfg.userEmail;

      extraConfig = {
        init.defaultBranch = "main";
        pull.rebase = false;
      };
    };
  };
}
