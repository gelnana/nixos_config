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
    heroic
    umu-launcher

    ## Modding
    limo
    nexusmods-app-unfree

    # communications
    discord
    mailspring

    # creative tools
    bitwig-studio
    yabridge
    krita
    gimp
    inkscape
    libreoffice-fresh

    # multimedia
    clementine
    ];
}
