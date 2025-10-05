#!/usr/bin/env bash

set -e

echo "Current latest remote commit:"
git ls-remote -h https://github.com/gelnana/nixos_config.git 
echo ""

# Check for fzf
if ! [ -x "$(command -v fzf)" ]; then
    echo "fzf: command not found."
    echo "Installing fzf"
    nix-env -iA nixos.fzf
fi

function yesno() {
    local prompt="$1"

    while true; do
        read -rp "$prompt [y/n] " yn
        case $yn in
            [Yy]* ) echo "y"; return;;
            [Nn]* ) echo "n"; return;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

cat << Introduction
This script will format the *entire* disk with a 1GB boot partition
(labelled NIXBOOT), 16GB of swap, then allocating the rest to ZFS.

OR BY CHOICE

This script will format selected by user boot, swap, root partitions
on already existing partition table.

The following ZFS datasets will be created on the root:
    - zroot/root (mounted at /)
    - zroot/nix (mounted at /nix)
    - zroot/home (mounted at /home)

Introduction

# in a vm, special case
if [[ -b "/dev/vda" ]]; then
    DISK="/dev/vda"
    
    BOOTDISK="${DISK}3"
    SWAPDISK="${DISK}2"
    ZFSDISK="${DISK}1"
else

cat << FormatWarning
YOUR DISK IS ABOUT TO BE FORMATTED

FormatWarning
    
install_type=$(yesno "Do you wish to install onto a whole empty disk [y]; or select existing partitions manually? [n];")

    if [[ $install_type == "y" ]]; then

# FULL DISK SELECTION

# Select whole disk
DISKINPUT=$(ls -r /dev/disk/by-id/ | fzf --prompt="Select disk to install nixos on [WITHOUT '-part']: " | cut -d ' ' -f 1)

        if [[ $DISKINPUT == *part* ]]; then
            echo "Error: Select full disk without 'part' in the id name."
            exit
        fi

        echo "Your disk is: $DISKINPUT"

        echo ""

        DISK="/dev/disk/by-id/${DISKINPUT}"
        # Check if the specified disk exists
        if [[ -e $DISK && ! -d $DISK ]]; then
            BOOTDISK="${DISK}-part1"
            SWAPDISK="${DISK}-part2"
            ZFSDISK="${DISK}-part3"
        else
            echo "Error: Selected disk not found in /dev/disk/by-id directory."
            exit
        fi

        # Selected partitions
        echo "Selected partitions:"
        echo "    Boot Partiton [NIXBOOT] - '$BOOTDISK'"
        echo "    SWAP Partiton [SWAP] - '$SWAPDISK'"
        echo "    ZFS Root Partiton [zroot] - '$ZFSDISK'"

        # Format Confirmation
        do_format=$(yesno "This irreversibly formats the entire disk. Are you sure?")
        if [[ $do_format != "y" ]]; then
            exit
        fi

        # warning countdown
        for i in {5..0}; do
            message="Formatting in $i seconds... <Ctrl + C> to EXIT NOW!\r"
            echo -e "\x1b[30;47m $message \x1b[0m"
            sleep 1
        done
        echo ""

        # DO INSTALL FULL DISK

        # RUN CHECKS
        echo "Checking mountpoint ''/mnt/boot':"
        # Check boot partition
        sudo mkdir -p /mnt/boot
        if mountpoint -q /mnt/boot; then
            echo "Unmounting /mnt/boot"
            sudo umount -f /mnt/boot || true
        fi

        echo "Checking swap status for: $SWAPDISK"
        # Check swap partition
        if [ -b "$SWAPDISK" ]; then
            swap_device=$(readlink -f "$SWAPDISK")
            echo "Swap device: $swap_device"

            # Check if the swap is currently on
            if swapon --show | grep -q "$swap_device"; then
                echo "Swap '$swap_device' is currently on."
                echo "Turning off SWAP device: $SWAPDISK"
                sudo swapoff "$SWAPDISK"
            else
                echo "Swap is already off. Continuing..."
            fi
        fi

        echo "Checking for zpool 'zroot' if exists"
        if zpool list zroot 2>/dev/null; then
            do_reinstall=$(yesno "'zroot' zfs pool already exists. Reinstall? [This will DESTROY zpool 'zroot'!]")
            if [[ $do_reinstall != "y" ]]; then
                echo "Make sure there is no zpool 'zroot' pool to install!"
                exit
            else
                # warning countdown
                for i in {5..0}; do
                    message="Destroying zpool 'zroot' in $i seconds... <Ctrl + C> to EXIT NOW\r"
                    echo -e "\x1b[30;47m $message \x1b[0m"
                    sleep 1
                done
                echo ""
                if mountpoint /mnt; then
                    sudo umount -R -f /mnt
                fi
                sudo zpool destroy zroot
            fi
        fi

        echo ""

        # POPULATE PARTITIONS ON THE WHOLE DISK
        echo "Creating partitions"
        sudo blkdiscard -f "$DISK"

        echo "Creating Boot partition"
        sudo sgdisk -n1:1M:+1G -t1:EF00 "$DISK"
        echo "Creating Swap partition"
        sudo sgdisk -n2:0:+16G -t2:8200 "$DISK"
        echo "Creating Root partition for the remainder of the disk"
        sudo sgdisk -n3:0:0 -t3:BF01 "$DISK"

        # notify kernel of partition changes
        sudo sgdisk -p "$DISK" > /dev/null
        sync
        sleep 5

        echo "Formatting Boot partition"
        sudo mkfs.fat -F 32 "$BOOTDISK"
        sudo fatlabel "$BOOTDISK" NIXBOOT

        echo "Setting up Swap"
        sudo mkswap "$SWAPDISK" -L "SWAP"
        sudo swapon "$SWAPDISK"

        # setup encryption
        use_encryption=$(yesno "Use encryption? (Encryption must also be enabled within host config.)")
        if [[ $use_encryption == "y" ]]; then
            encryption_options=(-O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt)
        else
            encryption_options=()
        fi

        echo ""
        echo "Created partitions: "
        lsblk -o NAME,SIZE,TYPE,LABEL,ID-LINK "$DISK"
        echo ""

        echo "Proceeding to ZFS setup on '${ZFSDISK}' ..."

    else

# MANUAL PARTITION SELECTION
        BOOTDISK_INPUT=$(ls -r /dev/disk/by-id/ | fzf --prompt="Select Boot Partition: " | cut -d ' ' -f 1)
        SWAPDISK_INPUT=$(ls -r /dev/disk/by-id/ | fzf --prompt="Select Swap Partition: " | cut -d ' ' -f 1)
        ZFSDISK_INPUT=$(ls -r /dev/disk/by-id/ | fzf --prompt="Select ZFS Root Partition [zroot]: " | cut -d ' ' -f 1)

        BOOTDISK="/dev/disk/by-id/${BOOTDISK_INPUT}"
        SWAPDISK="/dev/disk/by-id/${SWAPDISK_INPUT}"
        ZFSDISK="/dev/disk/by-id/${ZFSDISK_INPUT}"

        # CHECK Selected partitions
        echo "Selected partitions:"
        if [[ -e $BOOTDISK && ! -d $BOOTDISK ]]; then
            echo "    Boot Partiton [NIXBOOT] - '$BOOTDISK'"
        else
            echo "'$BOOTDISK' does not exist!"
            exit
        fi
        if [[ -e $SWAPDISK && ! -d $SWAPDISK ]]; then
            echo "    SWAP Partiton [SWAP] - '$SWAPDISK'"
        else
            echo "'$SWAPDISK' does not exist!"
            exit
        fi
        if [[ -e $ZFSDISK && ! -d $ZFSDISK ]]; then
            echo "    ZFS Root Partiton [zroot] - '$ZFSDISK'"
        else
            echo "'$ZFSDISK' does not exist"
            exit
        fi

        # Format Confirmation
        do_format=$(yesno "This irreversibly formats selected partitions. Are you sure?")
        if [[ $do_format != "y" ]]; then
            exit
        fi

        # warning countdown
        for i in {5..0}; do
            message="Formatting in $i seconds... <Ctrl + C> to EXIT NOW\r"
            echo -e "\x1b[30;47m $message \x1b[0m"
            sleep 1
        done
        echo ""

        # DO INSTALL MANUAL SELECTION

        # RUN CHECKS
        echo "Checking mountpoint ''/mnt/boot':"
        # Check boot partition
        sudo mkdir -p /mnt/boot
        if mountpoint -q /mnt/boot; then
            echo "Unmounting /mnt/boot"
            sudo umount -f /mnt/boot || true
        fi

        echo "Checking swap status for: $SWAPDISK"
        # Check swap partition
        if [ -b "$SWAPDISK" ]; then
            swap_device=$(readlink -f "$SWAPDISK")
            echo "Swap device: $swap_device"

            # Check if the swap is currently on
            if swapon --show | grep -q "$swap_device"; then
                echo "Swap '$swap_device' is currently on."
                echo "Turning off SWAP device: $SWAPDISK"
                sudo swapoff "$SWAPDISK"
            else
                echo "Swap is already off. Continuing..."
            fi
        fi

        echo "Checking for zpool 'zroot' if exists"
        if zpool list zroot 2>/dev/null; then
            do_reinstall=$(yesno "'zroot' zfs pool already exists. Reinstall? [This will DESTROY zpool 'zroot'!]")
            if [[ $do_reinstall != "y" ]]; then
                echo "Make sure there is no zpool 'zroot' pool to install!"
                exit
            else
                # warning countdown
                for i in {5..0}; do
                    message="Destroying zpool 'zroot' in $i seconds... <Ctrl + C> to EXIT NOW\r"
                    echo -e "\x1b[30;47m $message \x1b[0m"
                    sleep 1
                done
                echo ""
                if mountpoint /mnt; then
                    sudo umount -R -f /mnt
                fi
                sudo zpool destroy zroot
            fi
        fi
        
        # FORMAT PARTITIONS
       
        echo "Discarding selected partitions!"
        sudo blkdiscard -f "$BOOTDISK"
        sudo blkdiscard -f "$SWAPDISK"
        sudo blkdiscard -f "$ZFSDISK"

        # notify kernel of partition changes
        sudo sgdisk -p "$BOOTDISK" > /dev/null
        sudo sgdisk -p "$SWAPDISK" > /dev/null
        sudo sgdisk -p "$ZFSDISK" > /dev/null
        sync
        sleep 5

        echo "Setting up Swap"
        sudo mkswap "$SWAPDISK" -L "SWAP"
        sudo swapon "$SWAPDISK"

        echo "Formatting Boot Disk"
        sudo mkfs.fat -F 32 "$BOOTDISK"
        sudo fatlabel "$BOOTDISK" NIXBOOT

        # setup encryption
        use_encryption=$(yesno "Use encryption? (Encryption must also be enabled within host config.)")
        if [[ $use_encryption == "y" ]]; then
            encryption_options=(-O encryption=aes-256-gcm -O keyformat=passphrase -O keylocation=prompt)
        else
            encryption_options=()
        fi

        echo "Proceeding to ZFS setup..."

    fi
fi

# ZFS - WITHOUT PERSISTENCE

echo "Creating base zpool"
sudo zpool create -f \
    -o ashift=12 \
    -o autotrim=on \
    -O compression=zstd \
    -O acltype=posixacl \
    -O atime=off \
    -O xattr=sa \
    -O normalization=formD \
    -O mountpoint=none \
    "${encryption_options[@]}" \
    zroot "$ZFSDISK"

echo "Creating 'zroot/root' -> '/'"
sudo zfs create -o mountpoint=legacy zroot/root
sudo mount -t zfs zroot/root /mnt

# create the boot partition after creating root
echo "Mounting '$BOOTDISK' (ESP) -> '/mnt/boot'"
sudo mount --mkdir "$BOOTDISK" /mnt/boot

echo "Creating 'zroot/nix' -> '/mnt/nix'"
sudo zfs create -o mountpoint=legacy zroot/nix
sudo mount --mkdir -t zfs zroot/nix /mnt/nix

echo "Creating 'zroot/home' -> '/mnt/home'"
sudo zfs create -o mountpoint=legacy zroot/home
sudo mount --mkdir -t zfs zroot/home /mnt/home

echo ""
echo "ZFS mounts:"
mount | grep zfs

echo ""

echo "Listing of block devices: "
lsblk -o NAME,SIZE,TYPE,LABEL,ID-LINK

echo ""

echo "ZFS pools:"
zpool list
echo "ZFS filesystems: "
zfs list -t filesystem

echo ""
# use fzf to select host
host=$(echo -e "desktop\nlaptop" | fzf --prompt="Select a host to install: ")
echo "Selected host: ${host}"

echo ""
echo "Current Directory: $(pwd)"
flake_path=$(yesno "Use current pwd as flake path?")
if [[ $flake_path == "y" ]]; then
    echo "Installing NixOS"
    sudo nixos-install --flake .#$host
else
    read -rp "Enter git rev for flake (default: master): " git_rev
    echo "Installing NixOS..."
    sudo nixos-install --flake "github:gelnana/nixos_config/${git_rev:-master}#$host"
fi