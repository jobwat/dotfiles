# Quit unless interactive session
[ -z "$PS1" ] && return

export EDITOR="vim"
export SAVEHIST=50000

# autocomplete commands will include .hidden files
setopt glob_dots

# bind Bash comportment for Ctrl+U (clears beginning of the line)
bindkey \^U backward-kill-line

# disables zsh spelling correction for all commands
setopt NOCORRECTALL

# load more machine specific scripts at load
[ -f ${HOME}/scripts/sys-utils/my.rc ] && source ${HOME}/scripts/sys-utils/my.rc

# oh-my-zsh
export ZSH=$HOME/.oh-my-zsh
plugins=(git z docker fzf-tab dotenv kubectl starship)
source $ZSH/oh-my-zsh.sh

# load aliases scripts if defined
alias_dir=${HOME}/.aliases; [ -d $alias_dir ] && for i in `ls $alias_dir`; do source $alias_dir/$i; done

# load FZF fuzzy matcher
export FZF_DEFAULT_OPTS="--exact --no-sort"
export FZF_DEFAULT_COMMAND='ag -p ~/.ignore -g "" -f'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# change z to use fzf if used without parameter
unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && zshz "$*" && return
  cd "$(zshz -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
  which loadenv >/dev/null 2>&1 && source loadenv
}

which brew >/dev/null 2>&1 && eval "$(brew shellenv)"
