{
  config,
  pkgs,
  ...
    
  }:
{
   programs.yazi = {
      enable = true;
      plugins = {
          mount = pkgs.yaziPlugins.mount;
          git = pkgs.yaziPlugins.git;
          ouch = pkgs.yaziPlugins.ouch;
          chmod = pkgs.yaziPlugins.chmod;
          mactag = pkgs.yaziPlugins.mactag;
          starship = pkgs.yaziPlugins.starship;
          zfs = pkgs.yaziPlugins.time-travel;
          duckdb = pkgs.yaziPlugins.duckdb;
        };
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
     }; 
    
  }
