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
