# CMurtagh-LGTM's dotfiles

The nord theme is pretty cool :P.

If you have any suggestions or improvements please make a issue or pull request.

## Dependencies

Incomplete list

### Main
- LeftWM
- sxhkd
- dunst
- Alacritty
- zsh
    - powerlevel 10k
- feh
- rofi
- neovim
- eww
    - wmctrl
- delta
- picom
- cbonsai
- pass and rofi-pass
- neomutt
- neofetch
    - chafa
- calcurse

### Inside Scripts
- python
	- psutil
	- pilsectl
    - rich
- playerctl
- pactl
- imagemagick

### rofi-modi
- ddgr - todo

### Neovim
- fzy
- Universal ctags

### Neomutt
- mutt-wizard (my patch)
- links
- notmuch
- abook (todo)
- cronie

#### Language servers
- efm-langserver
    - black
    - isort
    - doq
    - flake8
        - isort
        - docstrings
        - blind except
    - mypy
- ccls
- jedi-language-server
- R languageserver
- vim-language-server
- texlab
- jdtls

### Zim
- zim
- fzy
- exa

### Font
- Hack Nerd Font

### Optional
- spotify for the eww widget

## Setting up Neovim
- `:PlugInstall`
- `:TSInstall <language-name>`

## Cool Stuff
- `bat` for coloured cat
- `git graph` alias to `git log --oneline --decorate --graph`

## Keybindings
Key 					| Action
------------------------|----------------------
mod4+p					| open rofi drun
mod4+o					| toggle eww
mod4+i                  | rofi todo
mod4+l                  | rofi pass
mod4+shift+return		| open Alacritty

Key 					| Action
------------------------|----------------------
mod4+numb				| go to workspace 1-10
mod4+ctrl+numb			| go to workspace 11-20
mod4+shift+numb 		| send to workspace

Key 					| Action
------------------------|----------------------
mod4+shift+c			| close window
mod4+shift+r			| soft reload wm
mod4+shift+esc          | reload sxhkd
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
media keys				| todo

## TODO
- images in neomutt
- Make notes - possible scratchpad from left with neorg
- rofi modi
    - browser bookmarks
    - browser seach ddgr, current one kinda sucks
    - rofi steam?
    - rofi spotify?
- add audio sinks to eww
- Add lock screen slock or xscreensaver
- add volume to eww
- work out all the neovim binary dependencies
- sort out vim autoclose brackets
- work out how to control where eww appears - given up on this
