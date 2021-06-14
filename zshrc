# for the autosuggestio/syntax/autocomplete: thery github repos, just download and move to /usr/share ; put a '.' in the beggining of this file name when using
PROMPT="%f%F{black}┌[%f%F{green}%m%f%F{black}]-[%f%F{yellow}%d%f%F{black}]%f"$'\n'"%F{black}└%f%F{green}$USER%f%F{bold black}$%f "
export PATH="$PATH:$HOME/.rvm/bin"

#alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'

# Auto complete
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 
source /usr/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh 
zstyle ':autocomplete:tab:' insert-anambiguos yes
zstyle ':autocomplete:tab:' widget-style menu-select
zstyle ':autocomplete:*' min-input 2

# Fish-like syntax
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Save history for easier life
HISTFIlE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory