fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src

export ZSH="$HOME/.oh-my-zsh"
export PATH="$PATH:/home/allusive/.emacs.d/bin"
export PATH="$PATH:/home/allusive/bin"
export ZSH_COMPDUMP="$ZSH/cache/.zcompdump"
export PATH="$PATH:/home/allusive/.local/share/mxw-master/target/release"

XDG_CONFIG_HOME="$HOME/.config"
XDG_DATA_HOME="$HOME/.local/share"
XDG_STATE_HOME="$HOME/.local/state"
XDG_CACHE_HOME="$HOME/.cache"

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

alias dgr="python manage.py runserver 0.0.0.0:8000"
alias xrecomp="xmonad --recompile"
alias xreset="xmonad --restart"
alias rebuild-switch="sudo nixos-rebuild switch --flake /home/allusive/.flake#nixos"
alias nixos-update="sudo nix-channel --update | sudo nixos-rebuild switch --flake /home/allusive/.flake#nixos"

#krabby random --no-title
nitch

ZSH_THEME="robbyrussell"

plugins=(
git
zsh-autosuggestions
zsh-completions
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"

alias ls="lsd -a"
