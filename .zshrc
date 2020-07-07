source ~/.zsh/instant-zsh.zsh
instant-zsh-pre "└───O))) "

# Fixing using nice on WSL
case $(uname -a) in
   *Microsoft*) unsetopt BG_NICE ;;
esac

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:/usr/local/go/bin:/home/linuxbrew/.linuxbrew/bin:~/go/bin/:$PATH

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
 COMPLETION_WAITING_DOTS="true"

eval $(thefuck --alias)
fuck-command-line() {
    local FUCK="$(THEFUCK_REQUIRE_CONFIRMATION=0 thefuck $(fc -ln -1 | tail -n 1) 2> /dev/null)"
    [[ -z $FUCK ]] && echo -n -e "\a" && return
    BUFFER=$FUCK
    zle end-of-line
}
zle -N fuck-command-line
bindkey '\e\e' fuck-command-line
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
#
source ~/agnoster_fork.zsh-theme
# source ~/agnoster_rainbow.zsh
# source ~/c/github/powerlevel10k/powerlevel9k.zsh-theme

# Run tmux at startup
# If not running interactively, do not do anything
[[ $- != *i* ]] && return
[[ -z "$TMUX" ]] && exec tmux

function my-expand-alias() { zle _expand_alias }
zle -N my-expand-alias
bindkey '^ ' my-expand-alias

bindkey -s "^y" "tmux save-buffer - | /mnt/c/Windows/System33/clip.exe\n"
bindkey '\e.' insert-last-word
bindkey '^R' history-incremental-search-backward
bindkey '^F' history-incremental-search-forward
# key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "^H" backward-delete-word

export TERM=xterm-256color

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
eval "`dircolors -b ~/.dircolors`"

export REPORTTIME=30

setopt CHASE_LINKS
setopt AUTO_LIST

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'
autoload -Uz compinit
compinit

cd ~

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -la'

alias grep='grep --color --exclude-dir={.bzr,CVS,.git,.hg,.svn}'

alias vimdiff='vimdiff -O'

alias gitcommits="git log --pretty=format:'%ci | %h | %s'"

alias c='cd /mnt/c/'
alias work='cd /mnt/c/workspace'

alias test-commit='echo test >> ./tst.tst; git add .; git commit -am "tst commit"; git push'
alias test-commit-sql='echo test >> ./tst.sql; git add .; git commit -am "tst commit"; git push'

alias gitlog_delivery='git --no-pager log -1000 --pretty=format:"%H %s"'





### Added by Zplugin's installer
source '/home/vkisel/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin installer's chunk
#
#
zplugin light zdharma/fast-syntax-highlighting 
FAST_HIGHLIGHT[chroma-git]="chroma/-ogit.ch"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#
#
alias ft='fzf-tmux --preview "bat --color \"always\" {}"'
alias fo='vim $(ft)'
# Nodejs
NODE_VERSION=v11.15.0
NODE_DISTRO=linux-x64
export PATH=/usr/local/lib/nodejs/node-$NODE_VERSION-$NODE_DISTRO/bin:$PATH


