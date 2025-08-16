{lib,
 pkgs,
 imports,
 ...
}:
{
programs.nixvim = {
  enable = true;
  imports = [ inputs.selkie.nixvimModule ];
  # Then configure Nixvim as usual, you might have to lib.mkForce some of the settings
  colorschemes.catppuccin.enable = lib.mkForce false;
  colorschemes.nord.enable = true;
};
}
