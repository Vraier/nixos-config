{
  lib,
  config,
  pkgs,
  ...
}: {
  services.kanshi.enable = true;

  services.kanshi.settings = [
    {
      profile.name = "default";
      profile.outputs = [
        {
          criteria = "PNP(BNQ) BenQ EX2780Q 55L00483019";
          position = "1920,0";
          mode = "2560x1440";
        }

        {
          criteria = "PNP(BNQ) BenQ G2450H V3C03772019";
          position = "0,0";
          mode = "1920x1080";
        }
      ];
    }
  ];
}
