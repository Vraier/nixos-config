{ colors, fonts }: ''
  * {
      border: none;
      border-radius: 0;
      font-family: "${fonts.monospace.name}", "Symbols Nerd Font"; 
      font-size: 16px;
      min-height: 0;
  }

  window#waybar {
      background: transparent; /* Transparent so we can see the gaps */
      color: #${colors.base05}; 
  }

  /* modules */
  .modules-left, .modules-center, .modules-right {
      background-color: alpha(#${colors.base00}, 1.0); 
      border: 0px solid #${colors.base01}; 
      padding: 4px 0px;
      border-radius: 15px;
      margin-bottom: 0px;

      margin-top: -15px; 
      padding-top: 20px;
  }
  .modules-left { 
      margin-left: -15px;
      padding-left: 20px;}
  .modules-right { 
      margin-right: -15px;
      padding-right: 20px; 
  }

  #hardware,
  #connectivity,
  #audio,
  #power,
  #context {
      background-color: #${colors.base01}; 
      padding: 4px 4px; 
      margin: 0 5px;
      border-radius: 15px;
      border: 2px solid #${colors.base02};
  }

  #hardware *, #connectivity *, #audio *, #power *, #context * {
      background-color: transparent;
      margin: 0px;
      padding: 0 8px; /* padding between modules inside group */
      border: none;
  }

  #workspaces {
      background-color: transparent;
      border: none;
      padding: 0;
      margin: 0;
  }
  #workspaces button { 
      color: #${colors.base04};
      border-radius: 10px;
  }
  #workspaces button.active {
      background-color: #${colors.base0D}; 
      color: #${colors.base00};            
      border-radius: 10px;
  }

  #cpu, #memory, #disk, #bluetooth, #idle_inhibitor, #pulseaudio {
      border-radius: 10px;
      transition: all 0.3s ease;
  }

  #idle_inhibitor.activated, #pulseaudio.muted {
      color: #${colors.base00};
      background-color: #${colors.base0C};
  }
  #cpu.warning, #memory.warning, #disk.warning { 
      color: #${colors.base00};
      background-color: #${colors.base0A}; 
  }
  #cpu.critical, #memory.critical, #disk.critical { 
      color: #${colors.base00};
      background-color: #${colors.base08}; 
  }
  #bluetooth.connected { 
      color: #${colors.base00};
      background-color: #${colors.base0D}; 
  }
  #network.disconnected { 
      color: #${colors.base00};
      background-color: #${colors.base0A}; 
  }

  /* Tooltips */
  tooltip {
      background-color: alpha(#${colors.base00}, 0.9);
      border: 2px solid #${colors.base0D};
      border-radius: 15px;
  }
  tooltip label {
      /* font-family: "${fonts.sansSerif.name}"; */
      font-size: 16px;
      color: #${colors.base05};
  }
''
