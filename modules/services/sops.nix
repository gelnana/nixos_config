{
    inputs,
    config,
    lib,
    user,
    ...
  }:
let
  secretspath = builtins.toString inputs.secrets;
  homeDir = config.hm.home.homeDirectory;
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
        };
        
       users.users.${user}.extraGroup = [ config.users.groups.keys.name ]; 
       
       };

    custom.persist.home = {
        directories = [ ".config/sops" ];
      };
  }
