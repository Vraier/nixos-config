# How to setup new host

- Create a new ssh key: `ssh-keygen -t ed25519 -C "jpvdheydt@googlemail.com" -f ~/.ssh/nixos-pc`
- Add `vscode` and `git` to the system packages. Also add flake features `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
- Rebuilt the system with `sudo nixos-rebuild switch`
- Clone this repository, create a new folder for the host and add it to `flake.nix`
- Copy over the important information from `hardwar-configuration.nix` and `configuration.nix`
- Rebuilt the flake with `sudo nixos-rebuild switch --flake ~/nixos-config#host-name`

# TODOs

- repaint images with stylix
- finish configuration of waybar
    - fix moving mute button
    - fix the privacy indicator
- explore options for niri
- explore awww wallpaper tool
- install sway-nc
- add zsh prompt
- fix steam
