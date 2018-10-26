# gerbus.zsh-theme

# Use with a dark background and 256-color terminal!
# Meant for people with RVM and git. Tested only on OS X 10.7.

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   fino-time
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST || echo $SHORT_HOST
}

unset -f work_in_progress # Delete the default function
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "%{$fg[red]%}WIP %{$reset_color%}"
  fi
}

function local_timezone() {
  if [ -f /etc/timezone ]; then
    cat /etc/timezone
  elif [ -h /etc/localtime ]; then
    echo $(readlink /etc/localtime | sed "s/\/usr\/share\/zoneinfo\///")
  else
    checksum=$(md5sum /etc/localtime | cut -d' ' -f1)
    echo $(find /usr/share/zoneinfo/ -type f -exec md5sum {} \; | grep "^$checksum" | sed "s/.*\/usr\/share\/zoneinfo\///" | head -n 1| sed "s/^[ \t]*//" | sed "s/^\/*//")
  fi
}

local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'
local is_wip='$(work_in_progress)'
local timezone='$(local_timezone)'

PROMPT="
%{$FG[255]%}╭─────%{$reset_color%}
 %{$FG[063]%}%n%{$reset_color%} at %{$FG[074]%}$(box_name)%{$reset_color%}
 %{$terminfo[bold]$FG[051]%}${current_dir}%{$reset_color%}
%{$FG[255]%}╰─────%{$reset_color%} ${git_info}${is_wip} %{$fg[159]%}➭%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[136]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[196]%} ✘ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[082]%} ✔ "
