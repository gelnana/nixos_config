{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.custom.programs.stylix;
  appleFonts =
    if lib.hasAttr "apple-fonts" inputs then
      inputs.apple-fonts.packages.${pkgs.system}
    else
      null;

  # helper to keep lists clean
  nonNull = xs: lib.filter (x: x != null) xs;
in {
  options.custom.programs.stylix = {
    enable = lib.mkEnableOption "Stylix user-level integration";

    autoEnable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Auto-enable stylix behaviour for new sessions (best-effort)";
    };

    polarity = lib.mkOption {
      type = lib.types.str;
      default = "dark";
      description = "Theme polarity (dark / light)";
    };

    image = lib.mkOption {
      type = lib.types.str;
      default = "$HOME/.config/stylix/wallpaper.jpg";
      description = "Path to wallpaper image (user path allowed, e.g. $HOME/.config/...)";
    };

    base16Scheme = lib.mkOption {
      type = lib.types.str;
      default = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      description = "Path to a Base16 scheme file (defaults to Catppuccin Mocha)";
    };

    opacity = lib.mkOption {
      type = lib.types.attrsOf lib.types.float;
      default = {
        applications = 0.93;
        terminal = 0.93;
      };
      description = "Opacity values for parts of the UI (0.0 - 1.0)";
    };

    fonts = lib.mkOption {
      type = lib.types.submodule;
      default = {
        # By default prefer apple-fonts if available via flake input, else null.
        serif = {
          package = if appleFonts != null then appleFonts."sf-pro-nerd" else null;
          name = "SFProText Nerd Font";
        };
        sansSerif = {
          package = if appleFonts != null then appleFonts."sf-pro-nerd" else null;
          name = "SFProText Nerd Font";
        };
        monospace = {
          package = if appleFonts != null then appleFonts."sf-mono-nerd" else null;
          name = "SFMono Nerd Font";
        };
        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
        sizes = {
          applications = 10;
          desktop = 10;
          popups = 10;
          terminal = 10;
        };
      };
      description = "Font packages & names to install for Stylix";
    };
  };

  config = lib.mkIf cfg.enable ({

    # Install chosen fonts (user-level via home.packages)
    home.packages = nonNull [
      (cfg.fonts.serif.package or null)
      (cfg.fonts.sansSerif.package or null)
      (cfg.fonts.monospace.package or null)
      (cfg.fonts.emoji.package or null)
      pkgs.base16-schemes
    ];

    home.sessionVariables = {
      STYLIX_POLARITY = cfg.polarity;
      STYLIX_WALLPAPER = cfg.image;
      STYLIX_BASE16 = cfg.base16Scheme;
      STYLIX_OPACITY_APPLICATIONS = toString cfg.opacity.applications;
      STYLIX_OPACITY_TERMINAL = toString cfg.opacity.terminal;
    };

    home.file.".config/stylix/config.json".text = lib.toJSON {
      polarity = cfg.polarity;
      wallpaper = cfg.image;
      base16 = cfg.base16Scheme;
      opacity = cfg.opacity;
      fonts = {
        serif = {
          name = cfg.fonts.serif.name;
          package = if cfg.fonts.serif.package != null then pkgs.lib.getName cfg.fonts.serif.package else null;
        };
        sansSerif = {
          name = cfg.fonts.sansSerif.name;
          package = if cfg.fonts.sansSerif.package != null then pkgs.lib.getName cfg.fonts.sansSerif.package else null;
        };
        monospace = {
          name = cfg.fonts.monospace.name;
          package = if cfg.fonts.monospace.package != null then pkgs.lib.getName cfg.fonts.monospace.package else null;
        };
        emoji = {
          name = cfg.fonts.emoji.name;
          package = if cfg.fonts.emoji.package != null then pkgs.lib.getName cfg.fonts.emoji.package else null;
        };
      };
      sizes = cfg.fonts.sizes;
      autoEnable = cfg.autoEnable;
    };
    home.file.".config/autostart/stylix-apply.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Stylix apply
      Exec=${pkgs.coreutils}/bin/true
      NoDisplay=true
    '';
  });
}
