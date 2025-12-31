{pkgs, ...}: let
  os-rebuild = pkgs.writeShellScriptBin "os-rebuild" ''
    export PATH=${pkgs.lib.makeBinPath [
      pkgs.git
      pkgs.alejandra
      pkgs.nvd
      pkgs.coreutils
    ]}:$PATH
    ${builtins.readFile ./os-rebuild.sh}
  '';

  audio-switch = pkgs.writeShellScriptBin "audio-switch" ''
    export PATH=${pkgs.lib.makeBinPath [
      pkgs.pulseaudio
      pkgs.pipewire
      pkgs.gnugrep
      pkgs.gnused
      pkgs.swayosd
      pkgs.coreutils
      pkgs.procps
      pkgs.gawk
    ]}:$PATH
    ${builtins.readFile ./audio-switch.sh}
  '';
in {
  home.packages = [
    os-rebuild
    audio-switch
  ];
}
