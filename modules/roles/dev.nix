{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.virtualisation;
in {
  config = lib.mkMerge [
    {
      environment.systemPackages = with pkgs;
        [
          git
          gcc
          gnumake
          cmake
          pkg-config
          virt-manager
          docker
        ]
        ++ [inputs.fenix.packages.${pkgs.system}.stable.toolchain];
      programs.direnv.enable = true;
    }
    (lib.mkIf cfg.enable {
      virtualisation.docker.enable = true;
      virtualisation.docker.storageDriver = "zfs";
      virtualisation.libvirtd.enable = true;
    })
  ];
}
