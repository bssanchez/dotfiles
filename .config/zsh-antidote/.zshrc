# .zshrc — antidote (prueba). Uso: ZDOTDIR=~/.config/zsh-antidote zsh

export ZSH_CACHE_DIR="$HOME/.cache/zsh"   # cache de completion de la lib de omz
[[ -d $ZSH_CACHE_DIR ]] || mkdir -p $ZSH_CACHE_DIR
export LC_ALL="es_CO.UTF-8"
export LANG="es_CO.UTF-8"
export ZSH_DISABLE_COMPFIX=true
export TERM="xterm-256color"
export LSCOLORS="exfxcxdxbxbxbxbxbxbxbx"
export LS_COLORS="di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=31;40:cd=31;40:su=31;40:sg=31;40:tw=31;40:ow=31;40:"
export DIFFPROG=delta

export XDG_DATA_HOME=$HOME/.local/share
export XDG_DATA_DIRS=/usr/local/share:/usr/share:$XDG_DATA_HOME

export NVM_DIR="/opt/nvm"
zstyle ':omz:plugins:nvm' autoload yes          # antes de cargar el plugin nvm
zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:nvm' silent-autoload yes   # auto-switch por .nvmrc sin el mensaje "Now using..."

# Con lazy, node/npm/npx son funciones de zsh y los procesos hijos (claude, opencode, MCPs) no los ven.
# Se pone en PATH el bin del alias default sin cargar nvm.sh; stable/node/lts/* toman la versión más alta.
_nvm_default_bin() {
  setopt local_options extended_glob null_glob
  local alias=$(<$NVM_DIR/alias/default 2>/dev/null) dirs
  [[ $alias == [0-9v]* ]] && dirs=($NVM_DIR/versions/node/v${alias#v}(|.*)(/nOn))
  (( $#dirs )) || dirs=($NVM_DIR/versions/node/v*(/nOn))
  (( $#dirs )) && echo $dirs[1]/bin
}
_nvm_bin=$(_nvm_default_bin) && export PATH=$_nvm_bin:$PATH
unset -f _nvm_default_bin; unset _nvm_bin

export VIRTUAL_ENV_DISABLE_PROMPT=0
export GOPATH="$HOME/.go"
export JAVA_HOME="/usr/lib/jvm/default"
export ANDROID_HOME="/opt/android-sdk"
export ANDROID_SDK_ROOT=$ANDROID_HOME
export SCALA_COURSIER_HOME="$HOME/.local/share/coursier"
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -XX:+IgnoreUnrecognizedVMOptions'
export CHROME_EXECUTABLE=/usr/bin/brave-nightly
export CHROME_BIN=/usr/bin/brave-nightly
export BROWSER="brave-nightly"
export EDITOR="nvim"
export PATH=/usr/local/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$HOME/.local/bin:/opt/flutter/bin:$GOPATH/bin:$SCALA_COURSIER_HOME/bin:$PATH

# Antidote — compinit va antes porque los plugins de omz llaman a compdef al cargar
fpath=(${ZDOTDIR:-$HOME}/completions $fpath)
autoload -Uz compinit && compinit -u
zstyle ':antidote:bundle' use-friendly-names 'on'
source $HOME/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

# Prompt (tema lain)
setopt PROMPT_SUBST
autoload -Uz colors && colors

# Versión de node en el prompt, solo en proyectos; lee de la ruta de nvm sin ejecutar node.
# Glyph nerd-font: 󰎙 (U+F0399); si tu font no lo pinta, prueba  U+E718 /  U+E24F.
node_prompt_info() {
  [[ -f package.json ]] || return
  local ver
  if [[ $NVM_BIN == */versions/node/* ]]; then
    ver=${${NVM_BIN#*/versions/node/}%%/*}   # versión activa de nvm
  elif [[ -r .nvmrc ]]; then
    ver=v${$(<.nvmrc)#v}                      # intención del proyecto, sin ejecutar node
  fi
  [[ -n $ver ]] && echo " %F{green}󰎙 %F{cyan}${ver}"
}

PROMPT='岩倉 玲音 %B%F{blue}:: %b%F{green}%3~ $(git_prompt_info)%F{magenta}$(virtualenv_prompt_info)%F{cyan}$(node_prompt_info)%f%B%(!.%F{red}.%F{blue})»%f%b '
RPS1='%(?..%F{red}%? ↵%f)'
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

# Aliases
alias cheatsheet='notify-send -t 15000 "CheatSheet" "$(cat ~/.cheatsheet)" >/dev/null 2>&1'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias emu="cd $ANDROID_HOME/tools && ./emulator"
alias docker_clean_images='docker rmi $(docker images -a --filter=dangling=true -q)'
alias docker_clean_ps='docker rm $(docker ps --filter=status=exited --filter=status=created -q)'
alias paste='curl -F "sprungie=<-" http://sprunge.us'
alias vim=nvim
alias ls="lsd --icon never"
alias k3sctl="sudo k3s kubectl"
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
alias anti='antigraviy'
alias rm="rm -i"

# zoxide + fzf (se activan solo si el binario existe)
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
if command -v fzf >/dev/null 2>&1; then
  if fzf --zsh >/dev/null 2>&1; then
    source <(fzf --zsh)
  else
    [ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh
    [ -f /usr/share/fzf/completion.zsh ]   && source /usr/share/fzf/completion.zsh
  fi
  if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
  fi
fi

[[ ! -f ~/.securerc ]] || source ~/.securerc

# Home/End/Insert/Del según terminal
bindkey '\e[1~'   beginning-of-line
bindkey '\e[H'    beginning-of-line
bindkey '\eOH'    beginning-of-line
bindkey '\e[2~'   overwrite-mode
bindkey '\e[3~'   delete-char
bindkey '\e[4~'   end-of-line
bindkey '\e[F'    end-of-line
bindkey '\eOF'    end-of-line

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh
# export PATH=/home/kid_goth/.opencode/bin:$PATH  # instalador curl de opencode 1.x; se usa el paquete de Arch
