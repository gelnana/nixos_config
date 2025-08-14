{ 
 fileSystems."/mnt/galatea" = {
    device = "/dev/disk/by-uuid/cd7fb9d4-168b-4004-a434-9fe331d76fd3";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
    ];
  };

  # Binding mounts
  # Pictures
  fileSystems."/home/gelnana/Pictures" = {
    device = "/mnt/galatea/Pictures";
    fsType = "none";
    options = [ "bind" ];
  };
  # Music
    fileSystems."/home/gelnana/Music" = {
    device = "/mnt/galatea/Music";
    fsType = "none";
    options = [ "bind" ];
  };
  # Documents
    fileSystems."/home/gelnana/Documents" = {
    device = "/mnt/galatea/Documents";
    fsType = "none";
    options = [ "bind" ];
  };
  # Downloads
    fileSystems."/home/gelnana/Downloads" = {
    device = "/mnt/galatea/Downloads";
    fsType = "none";
    options = [ "bind" ];
  };
  # Steam Library
    fileSystems."/home/gelnana/.local/share/Steam" = {
    device = "/mnt/galatea/Steam";
    fsType = "none";
    options = [ "bind" ];
  };
}
