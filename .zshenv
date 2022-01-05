# Start configuration added by Zim install {{{
#
# User configuration sourced by all invocations of the shell
#

# Define Zim location
: ${ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim}
# }}} End configuration added by Zim install

export EDITOR="/usr/bin/nvim"

export PATH="$PATH:$HOME/.local/bin"

# Make qt work
export QT_PLUGIN_PATH=/usr/lib/qt/plugins
