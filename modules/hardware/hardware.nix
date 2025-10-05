{lib, ...}: {
  options.custom = {
    zfs = {
      encryption =
        lib.mkEnableOption "zfs encryption"
        // {
          default = true;
        };
      snapshots =
        lib.mkEnableOption "zfs snapshots"
        // {
          default = true;
        };
    };
  };
}
