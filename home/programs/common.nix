{lib,
 pkgs,
 ...
}: {
    home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip

    # utils
    ripgrep
    yq-go
    htop

    # cloud
    docker-compose
    kubectl
    nodejs

    # games
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

    # communications
    discord
    mailspring

    # creative tools
    ## Music
    reaper
    reaper-sws-extension
    reaper-reapack-extension
    yabridge
    ## Art
    krita
    gimp
    inkscape

    # multimedia
    clementine
    libreoffice-fresh

    ];
}
