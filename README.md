# Cat NixOS dots
> loosely copied from @fufexan's[^fuf] dots

My Catppuccin[^cat] dotfiles written in nix, managed with home-manager[^hm]

## Meta

### Usage
```sh
nixos-rebuild switch --flake . --use-remote-sudo
```

### OS Support
Only NixOS is supported as of now, no nix-darwin, no NixNG, and no generic linux

### Screenshots
Don't exist, because I don't feel this is unique enough to be 
shown off ATM, this is just so I have a public place to show
my dots, but in the near future, that will not be the case 🙂

## Overview of components

### CLI

#### Shell
My shell is Z-shell[^zsh], prompt is Powerlevel10k[^pk], and my plugins are 
managed with home-manager[^hm], (Oh My ZSH free, and will always be)

#### Terminal
Good ol' Kitty[^kty] with JetBrains Mono Nerd[^jbm]

#### Fetch
Just Macchina[^mc] nothing special, cat is in `ascii.nix` 🙂

### GUI

#### GTK and Kvantum (QT)
Just using the respective themes from Catppuccin[^cat]

#### Compositor
Hyprland[^hypr], because who doesn't love Hyprland[^hypr]?

#### Bar/Shell
ATM its all yoinked from @fufexan[^fuf], which is built in eww[^eww].
Though don't use my setup as its mostly broken, 
working on a refactor in rust, and a refactor of menu.

#### Display Manager (AKA Login Manager)
Gtkgreet[^gtkg] running under Greetd[^gtd], running under cage[^cage], though 
the styling is pretty broken.

### Media

#### Music
For music I use DownOnSpot[^down] to download my music from 
Spotify (Not using bypass, I'm paying for premium),
which is tagged using beets[^beet], then that music is 
synced with Nextcloud[^ncld], and played through MPD[^mpd], 
which is controlled by ncmpcpp[^nc]

#### Non music (aka video)
I have a basic MPV[^mpv] setup configured, but that's it,
nothing special

### Secrets
NixOS secrets are managed through agenix[^anix]

#### Old home secret stuff
> This does not apply anymore, I use agenix for everything,
but my custom home secrets setup is still there is someone wants

Since agenix[^anix] doesn't support home secrets, nor 
did homeage[^hage] work for me, or work how I wanted it
too, I found it would be faster just to use write my own,
maybe I'll publish and improve my implementation later on

## TODO
- [ ] Add locking, and inhibiting of it

[^fuf]: [His profile](https://github.com/fufexan/)
[^hypr]: [Hyprland's repository](https://github.com/hyprwm/Hyprland/)
[^anix]: [Agenix's repository](https://github.com/ryantm/agenix/)
[^hage]: [Homeage's repository](https://github.com/jordanisaacs/homeage/)
[^nc]: [ncmpcpp's repository](https://github.com/ncmpcpp/ncmpcpp/)
[^mpd]: [MPD's website](https://musicpd.org/)
[^down]: [DownOnSpot's repository](https://github.com/oSumAtrIX/DownOnSpot/)
[^cat]: [Catppuccin's home repository](https://github.com/catppuccin/catppuccin/)
[^beet]: [Beet's website](https://beets.io/)
[^hm]: [Home Manager's repository](https://github.com/nix-community/home-manager/)
[^pk]: [Powerlevel10k's repository](https://github.com/romkatv/powerlevel10k/)
[^zsh]: [Z-Shell's website](https://zsh.sourceforge.io/)
[^mc]: [Macchina's repository](https://github.com/Macchina-CLI/macchina/)
[^kty]: [Kitty's website](https://sw.kovidgoyal.net/kitty/)
[^jbm]: [Jetbrains Mono's website](https://www.jetbrains.com/lp/mono/)
[^eww]: [Eww's repository](https://github.com/elkowar/eww/)
[^gtd]: [Greetd's repository](https://sr.ht/~kennylevinsen/greetd/)
[^gtkg]: [Gtkgreet's repository](https://git.sr.ht/~kennylevinsen/gtkgreet/)
[^mpv]: [MPV's website](https://mpv.io/)
[^ncld]: [Nextcloud's website](https://nextcloud.com/)
[^cage]: [Cage's repository](https://github.com/Hjdskes/cage/)
