{lib,
 pkgs,
 ...
}: {
    home.packages = with pkgs; [
    xivlauncher
    prismlauncher
    parallel-launcher
    wine
    bottles
    winetricks
    protontricks
    lutris
    vulkan-loader
    dxvk
    heroic
    umu-launcher

    ## Modding
    limo
    nexusmods-app-unfree
    ];
}
