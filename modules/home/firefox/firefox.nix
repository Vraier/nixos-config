{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        bitwarden
        sponsorblock
        youtube-shorts-block
      ];

      search = {
        force = true;
        default = "kagi";
        privateDefault = "google";
        order = [
          "kagi"
          "google"
        ];

        engines = {
          "kagi" = {
            urls = [{template = "https://kagi.com/search?q={searchTerms}";}];
            icon = "https://kagi.com/favicon.ico";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = ["@k"];
          };
        };
      };

      settings = {
        "browser.startup.page" = 3; # Resume previous session
        "browser.startup.homepage" = "https://kagi.com";
        "browser.newtabpage.enabled" = true;

        "browser.translations.enable" = false;
        "browser.translations.panelShown" = false;
        "browser.translations.automaticallyPopup" = false;

        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;

        "privacy.trackingprotection.enabled" = true;
        "dom.security.https_only_mode" = true;
      };
    };
  };

  # XDG Mime apps remain the same
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  stylix.targets.firefox.profileNames = ["default"];
}
