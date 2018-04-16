source ~/.zplug/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
# theme (https://github.com/sindresorhus/pure#zplug)　好みのスキーマをいれてくだされ。
zplug "nojhan/liquidprompt"
# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"
# history関係
zplug "zsh-users/zsh-history-substring-search"
# タイプ補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "chrissicool/zsh-256color"

zplug "b4b4r07/enhancd"
zplug "b4b4r07/easy-oneliner", if:"which fzf"
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
	printf "Install? [y/N]: "
    	if read -q; then
        	echo; zplug install
        fi
fi
# Then, source plugins and add commands to $PATH
zplug load

# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=10000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_all_dups
setopt hist_no_store          # historyコマンドは履歴に登録しない
setopt hist_verify            # ヒストリを呼び出してから実行する間に一旦編集可能
# 開始と終了を記録
setopt EXTENDED_HISTORY

setopt extended_glob
setopt auto_cd

bindkey -v

autoload -U compinit; compinit -C

autoload -Uz zmv
alias zmv='noglob zmv -W'
setopt auto_cd
eval "$(fasd --init auto)"

export GOPATH=$HOME
path=(/usr/local/go/bin(N-/) /usr/local/bin(N-/) $path)

if type pyenv >/dev/null 2>&1
then
    export PYENV_ROOT=$HOME/.pyenv
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"
fi

export ENHANCD_DIR=$HOME/.enhancd
if [ ! -d "$ENHANCD_DIR" ]; then
  mkdir -p "$ENHANCD_DIR"
fi

if [ ! -f "$ENHANCD_DIR/enhancd.log" ]; then
  touch "$ENHANCD_DIR/enhancd.log"
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function fzf-history-selection() {
  local tac
  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi
  BUFFER=$(history -n 1 | eval $tac | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER

  zle reset-prompt
}

function frepo() {
  local dir
  dir=$(ghq list > /dev/null | fzf-tmux --reverse +m) &&
    cd $(ghq root)/$dir
}

zle -N fzf-history-selection
bindkey '^r' fzf-history-selection

zle -N frepo
bindkey '^]' frepo