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
          position = "5120,400"; # 2560 + 2560 = 5120
          scale = 1.1;
        }
      ];
    }

    {
      profile.name = "chen";
      profile.outputs = [
        {
          criteria = "California Institute of Technology 0x1404 Unknown";
          position = "2560,800";
          mode = "1920x1080";
          scale = 1.1;
        }

        {
          criteria = "Lenovo Group Limited LEN P27u-10 0x4D33564C";
          position = "0,0";
          mode = "2560x1440";
        }
      ];
    }
  ];
}
