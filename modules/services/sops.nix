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
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        keyFile = "${homeDir}/.config/sops/age/keys.txt";
        generateKey = false;
      };
      secrets = {
        "${username}-password".neededForUsers = true;
        github_ssh_key = {
          owner = username;
          mode = "0600";
          path = "${homeDir}/.ssh/id_github";
        };
      };
    };
  };
}
