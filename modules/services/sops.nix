{ inputs, config, lib, username, ... }:

let
  secretDir = builtins.toString inputs.nix-secrets;
  homeDir = "/home/${username}";
in
{
  options.custom = with lib; {
    sops.enable = mkEnableOption "sops" // { default = true; };
  };

  config = lib.mkIf config.custom.sops.enable {
    sops = {
      age = {
        keyFile     = "/var/lib/sops/age/keys.txt";
        generateKey = false;
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      };

      secrets = {
        "${username}-password" = {
          file = "${secretDir}/${username}-password";
          neededForUsers = true;
        };

        github_ssh_key = {
          file  = "${secretDir}/github_ssh_key";
          path  = "${homeDir}/.ssh/id_github";
          owner = username;
          mode  = "0600";
        };
      };
    };
  };
}
