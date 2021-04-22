cbonsai -p

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/cameron/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

alias ls='ls --color=auto'

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

alias dotfile='/usr/bin/git --git-dir=$HOME/Documents/dotfiles/ --work-tree=$HOME'

# nnn

export NNN_PLUG='p:dragdrop;f:fzcd;o:fzopen;g:_git log --oneline --graph'

n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#####################################################################################################
# Uncomment / edit the following environment variables when the corresponding software is installed #
#####################################################################################################

# export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64  # Defines the path to Java home.
# export ROS_DISTRO=kinetic

#######################################################
# Edit these WEBOTS environment variables when needed #
#######################################################

export WEBOTS_DISABLE_SAVE_SCREEN_PERSPECTIVE_ON_CLOSE=1  # If defined, Webots will not save screen specific perspective changes when closed.
export WEBOTS_ALLOW_MODIFY_INSTALLATION=1                 # If defined, you are allowed to modify files in the Webots home using Webots.
# export WEBOTS_DISABLE_WORLD_LOADING_DIALOG=1            # If defined, the loading world progress dialog will never be displayed.

#########################################################################
# These environment variables are necessaries to compile and run Webots #
#########################################################################

export WEBOTS_HOME=$HOME/Documents/webots                                  # Defines the path to Webots home.
export LD_LIBRARY_PATH=$WEBOTS_HOME/lib/webots:$LD_LIBRARY_PATH  # Add the Webots libraries to the library path (useful when launching Webots directly without using the launcher).
