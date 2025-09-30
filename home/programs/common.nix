{ lib, pkgs, config, ... }:
let
  cfg = config.custom.programs.common;
in {
  options.custom.programs.common = {
    enable = lib.mkEnableOption "common utilities and applications";

    archives = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install archive tools (zip, unzip, p7zip)";
    };

    utils = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install common utilities (ripgrep, htop, etc)";
    };

    cloud = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install cloud/devops tools (docker-compose, kubectl)";
    };

    communications = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Discord and Mailspring";
    };

    downloads = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install download clients (qBittorrent, Nicotine+)";
    };

    organization = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install organization tools (Calibre, Zotero)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs;
      lib.optionals cfg.archives [
        zip
        unzip
        p7zip
      ]
      ++ lib.optionals cfg.utils [
        ripgrep
        yq-go
        htop
        jupyter-all
      ]
      ++ lib.optionals cfg.cloud [
        docker-compose
        kubectl
        nodejs
        ansible
      ]
      ++ lib.optionals cfg.communications [
        discord
        mailspring
      ]
      ++ lib.optionals cfg.downloads [
        qbittorrent
      ]
      ++ lib.optionals cfg.organization [
        calibre
        zotero_7
        qnotero
      ];
  };
}
