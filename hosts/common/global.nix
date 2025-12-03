{ inputs, outputs, pkgs, ... }: {
  imports = [
    ../../modules/system/default.nix # Import the "bundle" of modules
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.networkmanager.enable = true;
  services.xserver.enable = true;
  services.printing.enable = true;
  hardware.bluetooth.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Keyboard / Locale
  services.xserver.xkb = {
    layout = "de";
    variant = "us";
    options = "ctrl:nocaps";
  };
  console.useXkbConfig = true;


  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "jp";

  environment.systemPackages = with pkgs; [
    vim
    wget
    yazi
    helix
    bat 
    btop
    tree
    fzf
    nix-search-tv
  ];
}