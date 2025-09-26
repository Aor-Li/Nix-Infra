{ ... }:
let
  name = "feature/system/network/ssh";
in
{
  flake.modules.nixos.${name} =
    { ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          X11Forwarding = true;
          PasswordAuthentication = true;
          PubkeyAuthentication = true;
          PermitRootLogin = "prohibit-password";
        };
      };
    };
}
