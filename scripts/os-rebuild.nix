{pkgs, ...}:
pkgs.writeShellScriptBin "os-rebuild" (builtins.readFile ./os-rebuild.sh)
