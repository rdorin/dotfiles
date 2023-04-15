export ZSH=$DOTFILES/zsh

# add all functions
if [[ -d $DOTFILES/zsh/functions ]]; then
    for func in $DOTFILES/zsh/functions/*(:t); autoload -U $func
fi

########################################################
# Configuration
########################################################

# initialize autocomplete
# unless WARP
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  autoload -U compinit add-zsh-hook
  compinit
fi

prepend_path /usr/local/opt/grep/libexec/gnubin
prepend_path /usr/local/sbin
prepend_path $DOTFILES/bin
prepend_path $HOME/bin

# display how long all tasks over 10 seconds take
export REPORTTIME=10
export KEYTIMEOUT=1              # 10ms delay for key sequences

setopt NO_BG_NICE
setopt NO_HUP                    # don't kill background jobs when the shell exits
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS
setopt LOCAL_TRAPS
setopt PROMPT_SUBST

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt EXTENDED_HISTORY          # write the history file in the ":start:elapsed;command" format.
setopt HIST_REDUCE_BLANKS        # remove superfluous blanks before recording entry.
setopt SHARE_HISTORY             # share history between all sessions.
setopt HIST_IGNORE_ALL_DUPS      # delete old recorded entry if new entry is a duplicate.

setopt COMPLETE_ALIASES

# bind keys unless warp
if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  # make terminal command navigation sane again
  bindkey "^[[1;5C" forward-word                      # [Ctrl-right] - forward one word
  bindkey "^[[1;5D" backward-word                     # [Ctrl-left] - backward one word
  bindkey '^[^[[C' forward-word                       # [Ctrl-right] - forward one word
  bindkey '^[^[[D' backward-word                      # [Ctrl-left] - backward one word
  bindkey '^[[1;3D' beginning-of-line                 # [Alt-left] - beginning of line
  bindkey '^[[1;3C' end-of-line                       # [Alt-right] - end of line
  bindkey '^[[5D' beginning-of-line                   # [Alt-left] - beginning of line
  bindkey '^[[5C' end-of-line                         # [Alt-right] - end of line
  bindkey '^?' backward-delete-char                   # [Backspace] - delete backward
  if [[ "${terminfo[kdch1]}" != "" ]]; then
      bindkey "${terminfo[kdch1]}" delete-char        # [Delete] - delete forward
  else
      bindkey "^[[3~" delete-char                     # [Delete] - delete forward
      bindkey "^[3;5~" delete-char
      bindkey "\e[3~" delete-char
  fi
  bindkey "^A" vi-beginning-of-line
  bindkey -M viins "^F" vi-forward-word               # [Ctrl-f] - move to next word
  bindkey -M viins "^E" vi-add-eol                    # [Ctrl-e] - move to end of line
  bindkey "^J" history-beginning-search-forward
  bindkey "^K" history-beginning-search-backward

  # history-substring-search bindings
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

fi


########################################################
# Plugin setup
########################################################

if [[ $TERM_PROGRAM != "WarpTerminal" ]]; then
  export ZPLUGDIR="$CACHEDIR/zsh/plugins"
  [[ -d "$ZPLUGDIR" ]] || mkdir -p "$ZPLUGDIR"
  # array containing plugin information (managed by zfetch)
  typeset -A plugins

  zfetch mafredri/zsh-async async.plugin.zsh
  zfetch zsh-users/zsh-syntax-highlighting
  zfetch zsh-users/zsh-autosuggestions
  zfetch Aloxaf/fzf-tab
  zfetch zsh-users/zsh-history-substring-search
fi

if [[ -x "$(command -v fnm)" ]]; then
    eval "$(fnm env --use-on-cd)"
fi

[[ -e ~/.terminfo ]] && export TERMINFO_DIRS=~/.terminfo:/usr/share/terminfo

########################################################
# Setup
########################################################

if [ -f $HOME/.fzf.zsh ]; then
  source $HOME/.fzf.zsh
  export FZF_DEFAULT_COMMAND='fd --type f'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_DEFAULT_OPTS="--color bg:-1,bg+:-1,fg:-1,fg+:#feffff,hl:#993f84,hl+:#d256b5,info:#676767,prompt:#676767,pointer:#676767"
fi

# add color to man pages
export MANROFFOPT='-c'
export LESS_TERMCAP_mb=$(tput bold; tput setaf 2)
export LESS_TERMCAP_md=$(tput bold; tput setaf 6)
export LESS_TERMCAP_me=$(tput sgr0)
export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4)
export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)
export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
export LESS_TERMCAP_mr=$(tput rev)
export LESS_TERMCAP_mh=$(tput dim)

# prefer zoxide over z.sh
if [[ -x "$(command -v zoxide)" ]]; then
    eval "$(zoxide init zsh --hook pwd)"
else
  # source z.sh if it exists
  zpath="$(brew --prefix)/etc/profile.d/z.sh"
  if [ -f "$zpath" ]; then
      source "$zpath"
  fi
fi

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
    colorflag="--color"
else # macOS `ls`
    colorflag="-G"
fi

# look for all .zsh files and source them
config_files=($DOTFILES/zsh/*.zsh)
for file in $config_files[@]; do
  source "$file"
done

# If a ~/.zshrc.local exists, source it
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
# If a ~/.localrc zshrc exists, source it
[[ -a ~/.localrc ]] && source ~/.localrc

# add starship for prompt
eval "$(starship init zsh)"

# neofetch apple splash screen
neofetch
