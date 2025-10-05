{ inputs, pkgs, lib, config, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      git
      gcc
      gnumake
      cmake
      pkg-config
      virt-manager
      docker
    ] ++ [ inputs.fenix.packages.${pkgs.system}.stable.toolchain ];

    programs.direnv.enable = true;

    virtualisation.docker.enable = true;
    virtualisation.docker.storageDriver = "zfs";

    virtualisation.libvirtd.enable = true;
  };
}
