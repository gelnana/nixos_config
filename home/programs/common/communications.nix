{pkgs, ...}: {
  home.packages = with pkgs; [
    vesktop
    zoom-us
  ];
}
