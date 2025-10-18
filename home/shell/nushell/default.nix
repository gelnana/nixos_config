{
  lib,
  config,
  ...
}: let
  cfg = config.custom.shell.nushell;
in {
  options.custom.shell.nushell = {
    enable = lib.mkEnableOption "Nushell with custom configuration";

    enableCarapace = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Carapace completions";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      configFile.source = ./config.nu;

      extraConfig = ''
        let carapace_completer = {|spans|
          carapace $spans.0 nushell ...$spans | from json
        }
        $env.config = {
          show_banner: false,
          completions: {
            case_sensitive: false
            quick: true
            partial: true
            algorithm: "fuzzy"
            external: {
              enable: true
              max_results: 100
              completer: $carapace_completer
            }
          }
        }
        $env.PATH = ($env.PATH |
          split row (char esep) |
          prepend /home/myuser/.apps |
          append /usr/bin/env
        )
      '';

      shellAliases = {
        # for editor
        vi = "neovim";
        vim = "neovim";
        nvim = "neovim";
        # development environments
        jupdev = "nix-shell -p 'python3.withPackages(ps: with ps; [ numpy pandas jupyter euporie ])'";
      };
    };

    programs.carapace = lib.mkIf cfg.enableCarapace {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
