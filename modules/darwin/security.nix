{ ... }:
{
  security = {
    pam = {
      services.sudo_local = {
        enable = true;
        reattach = true;
        watchIdAuth = true;
        touchIdAuth = true;
      };
    };
  };
}
