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
    jupyter-all
    

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
    zotero_7
    qnotero
    ];
}
