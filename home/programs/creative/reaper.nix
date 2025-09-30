{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.programs.reaper;

  # Helper function to create plugin paths
  makePluginPath = format:
    (lib.makeSearchPath format [
      "$HOME/.nix-profile/lib"
      "/run/current-system/sw/lib"
      "/etc/profiles/per-user/$USER/lib"
    ])
    + ":$HOME/.${format}";
in {
  options.custom.programs.reaper = {
    enable = lib.mkEnableOption "Reaper DAW";

    enablePlugins = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install common audio plugins";
    };

    enableYabridge = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install yabridge for Windows VST support";
    };

    enableExtensions = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install Reaper extensions (SWS, ReaPack)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # The DAW
      reaper
    ] ++ lib.optionals cfg.enablePlugins [
      # Synths
      helm
      oxefmsynth
      bespokesynth
      fluidsynth

      # Effects
      aether-lv2
      x42-plugins
      airwindows-lv2
      mda_lv2
      noise-repellent
      speech-denoiser
      mod-distortion
      fomp
      gxplugins-lv2
      fverb
      mooSpace
      boops
      zam-plugins
      molot-lite
      bankstown-lv2

      # Utilities
      midi-trigger
      bshapr
      bchoppr

      # Soundfonts
      soundfont-generaluser
      soundfont-ydp-grand
    ] ++ lib.optionals cfg.enableYabridge [
      # Windows VST bridge
      yabridge
      yabridgectl
    ];

    # Plugin path environment variables
    home.sessionVariables = {
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    };

    # Reaper extensions
    xdg.configFile."REAPER" = lib.mkIf cfg.enableExtensions {
      source = pkgs.symlinkJoin {
        name = "reaper-userplugins";
        paths = with pkgs; [
          reaper-sws-extension
          reaper-reapack-extension
        ];
      };
      recursive = true;
    };
  };
}
