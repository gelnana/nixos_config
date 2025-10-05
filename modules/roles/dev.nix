{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.custom.dev;
in {
  options.custom.dev = {
    enable = lib.mkEnableOption "development tools";

    enableDocker = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Docker";
    };

    enableLibvirt = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable libvirt";
    };

    enableDirenv = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable direnv for per-project environments";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        inputs.fenix.packages.${pkgs.system}.stable.toolchain
        git
        gcc
        gnumake
        cmake
        pkg-config
      ]
      ++ lib.mkIf cfg.enableLibvirt [
        virt-manager
      ];

    programs.direnv.enable = cfg.enableDirenv;

    virtualisation.docker = lib.mkIf cfg.enableDocker {
      enable = true;
      storageDriver = "zfs";
    };

    virtualisation.libvirtd.enable = true;
  };
}
