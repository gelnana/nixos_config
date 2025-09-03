{lib,
 pkgs,
 ...
}: {
    home.packages = with pkgs; [
    xivlauncher
    prismlauncher
    parallel-launcher
    protontricks
    lutris
    heroic
    umu-launcher

    ## Modding
    limo
    nexusmods-app-unfree
    ];
}
