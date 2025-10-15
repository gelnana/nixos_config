{
  pkgs,
  lib,
  config,
  username,
  ...
}: let
  cfg = config.custom.audio;
in {

  options.custom.audio = {
    enable = lib.mkEnableOption "audio support with PipeWire";

    enableMusnix = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable musnix for low-latency audio production";
    };

    enableJack = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable JACK support";
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = cfg.enableJack;
    };

    services.pulseaudio.enable = false;

    musnix = lib.mkIf cfg.enableMusnix {
      enable = true;
      rtcqs.enable = true;
    };

    users.users.${username}.extraGroups =
      ["audio"]
      ++ lib.optional cfg.enableJack "jackaudio";

    environment.systemPackages = with pkgs;
      [
        sox
        alsa-lib
        alsa-utils
        pavucontrol
        helvum
        easyeffects
        pulseaudio
      ]
      ++ lib.optionals cfg.enableJack [
        qjackctl
        qpwgraph
        jack2
      ];
  };
}
