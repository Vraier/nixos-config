{
  lib,
  config,
  pkgs,
  ...
}: {
  services.kanshi.enable = true;

  services.kanshi.settings = [
    {
      profile.name = "undocked";
      profile.outputs = [
        {
          criteria = "eDP-1";
          scale = 1.25;
          status = "enable";
        }
      ];
    }

    {
      profile.name = "docked";
      profile.outputs = [
        {
          criteria = "Dell Inc. DELL P2720DC H2QVL93";
          position = "2560,0";
          mode = "2560x1440";
        }

        {
          criteria = "Dell Inc. DELL P2720DC B10TL93";
          position = "0,0";
          mode = "2560x1440";
        }

        {
          criteria = "eDP-1";
          position = "5120,0"; # 2560 + 2560 = 5120
          scale = 1.25;
        }
      ];
    }
  ];
}
