{ lib, pkgs, config, ... }:

let
  cfg = config.custom.programs.cloud;
in
{
  options.custom.programs.cloud = {
    enable = lib.mkEnableOption "Enable cloud utilities";

    dockerCompose = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Docker Compose";
    };

    kubectl = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install kubectl";
    };

    nodejs = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Node.js";
    };

    ansible = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Ansible";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; lib.concatLists [
      (if cfg.dockerCompose then [ pkgs.docker-compose ] else [])
      (if cfg.kubectl then [ pkgs.kubectl ] else [])
      (if cfg.nodejs then [ pkgs.nodejs ] else [])
      (if cfg.ansible then [ pkgs.ansible ] else [])
    ];
  };
}

