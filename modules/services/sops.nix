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
        sshKeyPaths = [ "/persist${homeDir}/.ssh/id_ed25519-desk" ];
        keyFile = "/persist${homeDir}/.config/sops/age/keys.txt";
        generateKey = false;
      };
      secrets = {
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

    users.users.${username}.extraGroups = [ config.users.groups.keys.name ];

    custom.persist.home = {
      directories = [
        ".config/sops"
        ".ssh"
      ];
    };
  };
}
