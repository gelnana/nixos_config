{ config, pkgs, ... }:

let
  sops-nix = import (builtins.fetchTarball "https://github.com/Mic92/sops-nix/archive/refs/tags/23.08.1.tar.gz") {};
in
{
  programs.ssh.enable = true;

  # SOPS-Nix will decrypt the private key at build time
  home.file.".ssh/github_deploy_key".source = sops-nix.decryptFile {
    encryptedFile = ./github_deploy_key.enc; # <-- your encrypted deploy key
  };

  # Extra SSH config for GitHub
  programs.ssh.extraConfig = ''
    Host github.com
      User git
      IdentityFile ~/.ssh/github_deploy_key
      IdentitiesOnly yes
  '';

  # Add known_hosts for GitHub
  home.file.".ssh/known_hosts".text = builtins.readFile ./github_known_hosts;
}
