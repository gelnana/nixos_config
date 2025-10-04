{ config, lib, pkgs, ... }:

let
  cfg = config.custom.ssh or {};
in {
  options.custom.ssh = {
    enable = lib.mkEnableOption "Enable SSH server with custom settings";
    enableX11Forwarding = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable X11 forwarding";
    };
    permitRootLogin = lib.mkOption {
      type = lib.types.str;
      default = "no";
      description = "Permit root login over SSH (yes/no/prohibit-password)";
    };
    passwordAuthentication = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow password authentication";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically open firewall port 22";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;
    services.openssh = {
      settings = {
        X11Forwarding = cfg.enableX11Forwarding;
        PermitRootLogin = cfg.permitRootLogin;
        PasswordAuthentication = cfg.passwordAuthentication;
        };
      openFirewall = cfg.openFirewall;
      allowSFTP = true;
    };
};
}
