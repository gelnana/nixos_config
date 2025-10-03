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
        sshKeyPaths = [/persist${homeDir}/.ssh/id_ed25519-desk];
        keyFile = "";
        generateKey = false;
      };
      secrets = {
        github_ssh_key = {
          owner = username;
          mode = "0600";
          path = "${homeDir}/.ssh/id_github";
        };
      };
    };

    custom.persist = {
      home.directories = [ ".ssh" ".config/sops/age" ];
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
