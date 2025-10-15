{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.vpn or {};
in {
  options.custom.vpn = {
    enable = lib.mkEnableOption "Enable Mullvad VPN with GUI";

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Start Mullvad daemon on boot";
    };

    enableCLI = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install CLI tools alongside GUI";
    };
  };

  config = lib.mkIf cfg.enable {
    services.mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    boot.kernelModules = [ "tun" ];

    systemd.services.mullvad-daemon = lib.mkIf cfg.autoStart {
      wantedBy = [ "multi-user.target" ];
    };

    environment.systemPackages = with pkgs; [
      mullvad-vpn
    ];
  };
}
