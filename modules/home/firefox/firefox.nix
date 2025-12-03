{ lib, config, pkgs, ... }:

{
  options = {
    modules.firefox.enable = lib.mkEnableOption "Enable Firefox & Default Browser";
  };

  config = lib.mkIf config.modules.firefox.enable {
    programs.firefox = {
        enable = true;
        
        policies = {
        # 1. Preferences: Restore tabs on startup
        Preferences = {
            "browser.startup.page" = 3; 
            "browser.startup.homepage" = "https://nixos.org";
            "browser.newtabpage.enabled" = true;
        };

        # 2. Search Engines: Kagi Default
        SearchEngines = {
            Default = "Kagi";
            PreventInstalls = true;
            Add = [
            {
                Name = "Kagi";
                URLTemplate = "https://kagi.com/search?q={searchTerms}";
                Method = "GET";
                IconURL = "https://kagi.com/favicon.ico";
                Alias = "@k"; 
            }
            ];
        };

        # 3. Extensions
        ExtensionSettings = {
            # Bitwarden
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
            installation_mode = "force_installed";
            };

            # uBlock Origin
            "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "force_installed";
            };

            # SponsorBlock
            "sponsorBlocker@ajay.app" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
            installation_mode = "force_installed";
            };
        };
        };
    };

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
  };
}