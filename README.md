# CMurtagh-LGTM's dotfiles

The nord theme is pretty cool :P.

If you have any suggestions or improvements please make a issue or pull request.

## Dependencies

Incomplete list

### Main
- LeftWM
- polybar
- dunst
- zsh
- powerlevel 10k
- feh
- xbindkeys
- rofi
- neovim
- eww
- delta
- nnn
- picom
- cbonsai
- rofi-todo https://github.com/samedamci/rofi-todo

### Inside Scripts
- python
	- psutil
	- pilsectl
- playerctl
- pactl

### Neovim
- fzf
- Universal ctags

### Font
- Hack
	- Patched with nerdfont

### Optional
- spotify for the eww widget

## Cool Stuff
- `n` for filebrowser
- `bat` for coloured cat
- `batman`
- `git-graph` alias to `git log --oneline --decorate --graph`
- [libxft-bgra](https://aur.archlinux.org/packages/libxft-bgra/) so `st` can display coloured emoji

## Keybindings
Key 					| Action
------------------------|----------------------
mod4+p					| open rofi drun
mod4+o					| toggle eww
mod4+i                  | rofi todo
mod4+shift+return		| open st

Key 					| Action
------------------------|----------------------
mod4+numb				| go to workspace 1-10
mod4+ctrl+numb			| go to workspace 11-20
mod4+shift+numb 		| send to workspace

Key 					| Action
------------------------|----------------------
mod4+shift+c			| close window
mod4+shift+r			| soft reload wm
mod4+shift+q			| quit wm

Key 					| Action
------------------------|----------------------
mod4+right				| next screen
mod4+left				| prev screen
mod4+shift+up			| move window up
mod4+shift+dowm			| move window down
mod4+return				| move window top

Key 					| Action
------------------------|----------------------
mod4+ctrl+up			| next layout
mod4+ctrl+down			| prev layout

Key 					| Action
------------------------|----------------------
mod4+space				| close notification
mod4+shift+space		| close all notification
mod4+ctrl+space			| notification history
mod4+shift+ctrl+space	| notification context menu

Key 					| Action
------------------------|----------------------
media keys				| .xbindkeysrc

## TODO
- fix nord rofi symlink
- setup pass
- Make notes better
- add audio sinks to eww
- Add lock screen slock or xscreensaver
- add volume to eww
- work out how to control where eww appears
- look into nnn more
- nnn opener
- work out all the neovim binary dependencies
- make vim python not slow
- sort out vim autoclose brackets
- vim indent block and comment block
- make or find airline nord theme
- mess around with neofetch
