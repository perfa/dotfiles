# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
setopt NO_CASE_GLOB
setopt PROMPT_SUBST
setopt autoparamslash
zstyle ':completion:*' special-dirs true

[[ -e ~/.common.alias ]] && builtin . ~/.common.alias
[[ -e ~/.common.env ]] && builtin . ~/.common.env

PROMPT='[%B%F{magenta}%?%f%b]${debian_chroot:+($debian_chroot)}%B%F{green}%n@%m%f%b:%F{yellow}$(__git_ps1 "(%s)")%f:%B%F{blue}%~%f%b$ '

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
