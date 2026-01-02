{
  colors,
  fonts,
}: ''
   * {
       border: none;
       border-radius: 0;
       font-family: "JetBrains Mono", "${fonts.emoji.name}";
       font-size: 16px;
       min-height: 0;
   }

   window#waybar {
       background: transparent;
       color: #${colors.base05};
   }

   /* modules */
   .modules-left, .modules-center, .modules-right {
       background-color: alpha(#${colors.base00}, 1.0);
       /* border: 2px solid #${colors.base02};  */
       padding: 5px 0px;
       border-radius: 20px;
       margin-bottom: 0px;
       margin-top: -22px;
       padding-top: 25px;
   }
   .modules-left {
       margin-left: -20px;
       padding-left: 25px;}
   .modules-right {
       margin-right: -20px;
       padding-right: 25px;
   }
   .modules-center {
       padding-left: 5px;
       padding-right: 5px;
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
       /* border: 2px solid #${colors.base02}; */
   }

   #hardware *, #connectivity *, #audio *, #power *, #context * {
       background-color: transparent;
       margin: 0px;
       padding: 0 8px; /* padding between modules inside group */
       border: none;
   }

   #workspaces {
       border: none;
       padding: 0;
       margin: 0;
   }
   #workspaces button {
       color: #${colors.base03};
       font-weight: bold;
       font-size: 20px;
       background-color: transparent;
       border-radius: 15px;
       min-width: 30px;
       border: 0px solid #${colors.base02};
       transition: all 0.3s ease;
  }
   #workspaces button.visible {
       background-color: #${colors.base02};
       color: #${colors.base05};
   }
   #workspaces button.active {
       color: #${colors.base00};
       background-color: #${colors.base0D};
   }
   #workspaces button.urgent {
       color: #${colors.base00};
       background-color: #${colors.base08};
   }
   #workspaces button:hover {
       background-color: #${colors.base02};
       color: #${colors.base05};
   }

   #custom-nixos-logo {
       font-size: 24px;
       padding: 0px 0px;
       margin: 0px 8px;
       background-color: transparent;
       border: none;
   }

   #cpu, #memory, #disk, #bluetooth, #idle_inhibitor, #network {
       border-radius: 10px;
       transition: all 0.3s ease;
   }

   #pulseaudio {
       /* Fix moving mute button */
       border-radius: 10px;
       transition: all 0.3s ease;
       min-width: 600px;
   }

   #pulseaudio.bluetoothed {
       color: #${colors.base00};
       background-color: #${colors.base0D};
   }
   #pulseaudio.source-muted {
       color: #${colors.base00};
       background-color: #${colors.base0A};
   }
   #pulseaudio.muted {
       color: #${colors.base03};
   }
   #idle_inhibitor.activated{
       color: #${colors.base00};
       background-color: #${colors.base0B};
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
