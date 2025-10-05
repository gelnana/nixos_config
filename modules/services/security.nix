{
  config,
  pkgs,
  ...
}: {
  security.polkit.enable = true;
  services.gnome = {
    gnome-keyring.enable = true;
  };
  programs.seahorse.enable = true;

  programs.ssh.startAgent = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
}
