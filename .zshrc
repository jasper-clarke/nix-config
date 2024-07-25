PS1=""

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000

export PATH="$HOME/.local/bin:$PATH"

# Completions
# fpath+="$HOME/.myzsh/zsh-completions/src"

autoload -U compinit
zstyle ':completion:*' menu select

bindkey -v

# Syntax highlighting and autosuggestions
source $HOME/.myzsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/.myzsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.myzsh/zsh-completions/zsh-completions.plugin.zsh

# Yazi integration
# function yy() {
#   local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
#   yazi "$@" --cwd-file="$tmp"
#   if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
#     builtin cd -- "$cwd"
#   fi
#   rm -f -- "$tmp"
# }

source $HOME/.myzsh/zsh-defer/zsh-defer.plugin.zsh

# Prompt
zsh-defer eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.json)"
# Zoxide integration
eval "$(zoxide init zsh)"

# Kitty integration
if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
  kitty-integration
  unfunction kitty-integration
fi

alias -- 'cd'='z'
alias -- 'rm'='trash-put'
