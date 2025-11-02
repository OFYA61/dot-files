export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"

ZSH_THEME="jnrowe"

source $ZSH/oh-my-zsh.sh

bindkey -v

plugins=(
  git
  fzf
  extract
  rust
  vi-mode
)

# Add bob nvim manager to PATH
export PATH="/opt/nvim/:$PATH"

alias armgcc="arm-linux-gnueabihf-gcc -static"

scripts_dir="$HOME/src/repos/dot-files/scripts"

if [ -d "$scripts_dir" ]; then
  for file in "$scripts_dir"/*.sh; do
    if [ -f "$file" ]; then
      source "$file"
    fi
  done
else
  echo "Could not find scripts directory '$scripts_dir'"
fi

COMPLETION_WAITING_DOTS="true"

alias fans_silent="echo silent | sudo tee /sys/devices/platform/msi-ec/fan_mode"
alias fans_auto="echo auto | sudo tee /sys/devices/platform/msi-ec/fan_mode"
alias fans_advanced="echo advanced | sudo tee /sys/devices/platform/msi-ec/fan_mode"
