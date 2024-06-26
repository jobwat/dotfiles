# Quit unless interactive session
[ -z "$PS1" ] && return

if [[ `uname` =~ 'Darwin' ]]; then
  # MacOS

  # Keypad from USB keyboard needs help under zsh since Yosemite (10.10) update
  # thx Robin Daugherty - http://superuser.com/a/830850/91702
  # 0 . Enter
  bindkey -s "^[Op" "0"
  bindkey -s "^[On" "."
  bindkey -s "^[OM" "^M"
  # 1 2 3
  bindkey -s "^[Oq" "1"
  bindkey -s "^[Or" "2"
  bindkey -s "^[Os" "3"
  # 4 5 6
  bindkey -s "^[Ot" "4"
  bindkey -s "^[Ou" "5"
  bindkey -s "^[Ov" "6"
  # 7 8 9
  bindkey -s "^[Ow" "7"
  bindkey -s "^[Ox" "8"
  bindkey -s "^[Oy" "9"
  # + -  * /
  bindkey -s "^[Ol" "+"
  bindkey -s "^[Om" "-"
  bindkey -s "^[Oj" "*"
  bindkey -s "^[Oo" "/"

  if [[ $TERM_PROGRAM == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]] {
    function chpwd {
      local SEARCH=' '
      local REPLACE='%20'
      local PWD_URL="file://$HOSTNAME${PWD//$SEARCH/$REPLACE}"
      printf '\e]7;%s\a' "$PWD_URL"
    }
    chpwd
  }
fi

export EDITOR="vim"
export SAVEHIST=50000
export PROMPT_EOL_MARK='' # remove the default % added by zsh when the output has no EndOfLine - https://unix.stackexchange.com/questions/167582/why-zsh-ends-a-line-with-a-highlighted-percent-symbol

# oh-my-zsh configuration
export ZSH=$HOME/.oh-my-zsh
# Set to the name theme to load. (Look in ~/.oh-my-zsh/themes/)
export ZSH_THEME="josh"
# oh-my-zsh still: do not check for upgrade by default, it's freaking annoying !
export DISABLE_AUTO_UPDATE="true"
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git z docker fzf-tab dotenv)
source $ZSH/oh-my-zsh.sh

# update josh theme prompt slightly
PROMPT='
%n@%m $(josh_prompt)
%(?,%{%F{green}%},%{%F{red}%})$%{$reset_color%} '

# autocomplete commands will include .hidden files
setopt glob_dots

# bind Bash comportment for Ctrl+U (clears beginning of the line)
bindkey \^U backward-kill-line

# Customize to your needs...
setopt NOCORRECTALL

# load more machine specific scripts at load
[ -f ${HOME}/scripts/sys-utils/my.rc ] && source ${HOME}/scripts/sys-utils/my.rc

# load aliases scripts if defined
alias_dir=${HOME}/.aliases; [ -d $alias_dir ] && for i in `ls $alias_dir`; do source $alias_dir/$i; done

# display eventual .rc messages
find ~/.rc-msgs -type f -exec sh -c 'cat "{}" | sed "s#^#\[{}\] #"' \;

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

eval "$(brew shellenv)"
