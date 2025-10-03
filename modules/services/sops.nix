{
  inputs,
  config,
  lib,
  username,
  ...
}:
let
  secretspath = builtins.toString inputs.secrets;
  homeDir = config.users.users.${username}.home;
in
{
  options.custom = with lib; {
    sops.enable = mkEnableOption "sops" // {
      default = true;
    };
  };

  config = lib.mkIf config.custom.sops.enable {
    sops = {
      defaultSopsFile = "${secretspath}/secrets.yaml";
      age = {
        sshKeyPaths = [];
        keyFile = "/etc/sops/age/keys.txt";
        generateKey = false;
      };
      secrets = {
        root-password = {
          neededForUsers = true;
        };
        gelnana-password = {
          neededForUsers = true;
        };
        github_ssh_key = {
          owner = username;
          mode = "0600";
          path = "${homeDir}/.ssh/id_github";
        };
      };
    };

    users.users = {
      root.hashedPasswordFile = lib.mkForce config.sops.secrets.root-password.path;
      ${username}.hashedPasswordFile = lib.mkForce config.sops.secrets.gelnana-password.path;
    };

    users.users.${username}.extraGroups = [ config.users.groups.keys.name ];

    custom.persist = {
      home.directories = [ ".ssh" ];
      root = {
        files = [
          "/etc/shadow/root"
          "/etc/shadow/${username}"
          "/etc/sops/age/keys.txt"
        ];
      };
    };
  };
}
