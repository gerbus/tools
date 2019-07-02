# gerbus.zsh-theme

# Use with a dark background and 256-color terminal!
# Meant for people with oh-my-zsh and git.

# You can set your computer name in the ~/.box-name file if you want.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo $HOST || echo $SHORT_HOST
}

# Get a color code based on the first and last characters of a passed string
function char_to_color_map {
   # map a number in range [65,122] (alpha char) 
   #   to range segments [34,51] [106,123] [124,141] [196,231] (bright colors)
   a1=65
   a2=122

   # map to [1,90] as intermediate step
   b1=1
   b2=90
   y=$(( b1 + ($1 - a1) * (b2 - b1) / (a2 - a1) ))

   # map to segments
   if ((y <= 18)); then
     echo "$(( $y + 33 ))"
   elif ((y <= 54)); then
     echo "$(( $y + 87 ))"
   else
     echo "$(( $y + 141 ))"
   fi
}
function color_code {
   #printf '%03d\n' "'$1[0,1]"
   char_code1=$(printf "%d\n" "'$1[0,1]")
   char_code2=$(printf "%d\n" "'$1[-1]")
   ((avg=($char_code1+$char_code2)/2))
   printf '%03d\n' "$(char_to_color_map $avg)"
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
%{$FG[$(color_code $(box_name))]%}╭─────%D{%F %T}%{$reset_color%}
 %{$FG[$(color_code $USER)]%}%n%{$reset_color%} at %{$FG[$(color_code $(box_name))]%}$(box_name)%{$reset_color%}
 %{$terminfo[bold]$FG[051]%}${current_dir}%{$reset_color%}
%{$FG[$(color_code $(box_name))]%}╰─────%{$reset_color%} ${git_info}${is_wip} %{$fg[159]%}➭%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[136]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[196]%} ✘ "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[082]%} ✔ "
