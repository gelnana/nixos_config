{ lib, config, pkgs, ... }:
let
  cfg = config.custom.soulseek;
in {
  options.custom.soulseek = {
    enable = lib.mkEnableOption "Soulseek P2P file sharing";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nicotine-plus;
      description = "Soulseek client package";
      example = "pkgs.nicotine-plus or pkgs.slskd";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall ports for Soulseek";
    };

    ports = {
      listening = lib.mkOption {
        type = lib.types.port;
        default = 2234;
        description = "Primary listening port";
      };

      obfuscated = lib.mkOption {
        type = lib.types.port;
        default = 2235;
        description = "Obfuscated port (optional)";
      };
    };

    allowedUDPPortRanges = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          from = lib.mkOption {
            type = lib.types.port;
            description = "Start of port range";
          };
          to = lib.mkOption {
            type = lib.types.port;
            description = "End of port range";
          };
        };
      });
      default = [
        { from = 2234; to = 2234; }
      ];
      description = "UDP port ranges to open for Soulseek";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install the Soulseek client
    environment.systemPackages = [ cfg.package ];

    # Open firewall ports
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.ports.listening
        cfg.ports.obfuscated
      ];

      allowedUDPPortRanges = cfg.allowedUDPPortRanges;
    };
  };
}
