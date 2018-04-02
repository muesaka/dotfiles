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

eval "$(fasd --init auto)"

export GOPATH=$HOME
path=(/usr/local/go/bin(N-/) /usr/local/bin(N-/) $path)
