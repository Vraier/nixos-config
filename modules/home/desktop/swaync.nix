{ pkgs, ... }: {

  services.swaync = {
    enable = true;
    
    # General Settings (The 'config.json' equivalent)
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "user";
      
      # The "Do Not Disturb" widget settings
      widgets = [
        "inhibit"
        "title"
        "dnd"
        "mpris"    # Media controls
        "notifications"
      ];
      
      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };

    # Styling (The 'style.css' equivalent)
    # Since you use Stylix, you might not need much here, 
    # but this is how you add custom CSS if needed:
    style = ''
      .notification {
        border-radius: 12px;
        box-shadow: 0 0 10px rgba(0,0,0,0.5);
      }
      .control-center {
        border-radius: 24px;
        background: rgba(20, 20, 20, 0.9);
      }
    '';
  };

}