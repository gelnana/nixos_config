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
    ansible

    # communications
    discord
    mailspring

    # download client
    qbittorrent
    nicotine-plus

    # organization
    calibre
    ];
}
