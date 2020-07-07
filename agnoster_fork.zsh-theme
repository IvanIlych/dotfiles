# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://github.com/Lokaltog/powerline-fonts).
# Make sure you have a recent version: the code points that Powerline
# uses changed in 2012, and older versions will display incorrectly,
# in confusing ways.
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](https://iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# If using with "light" variant of the Solarized color schema, set
# SOLARIZED_THEME variable to "light". If you don't specify, we'll assume
# you're using the "dark" variant.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
DEFAULT_FG='default'
PERIOD=10

case ${SOLARIZED_THEME:-dark} in
    light) CURRENT_FG='white';;
    *)     CURRENT_FG='black';;
esac

OC_REFRESH_NEEDED=false
IS_INSODE_GIT_WORK_TREE=1

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  # NOTE: This segment separator character is correct.  In 2012, Powerline changed
  # the code points they use for their special characters. This is the new code point.
  # If this is not working for you, you probably have an old version of the
  # Powerline-patched fonts installed. Download and install the new version.
  # Do not submit PRs to change this unless you have reviewed the Powerline code point
  # history and have new information.
  # This is defined using a Unicode escape sequence so it is unambiguously readable, regardless of
  # what font the user is viewing this source code in. Do not replace the
  # escape sequence with a single literal character.
  # Do not change this! Do not make it '\u2b80'; that is the old, wrong code point.
  SEGMENT_SEPARATOR=$'\ue0b1'
  R_SEGMENT_SEPARATOR=$'\ue0b3'
  # SEGMENT_SEPARATOR=$'\ue0c8'
  # e0d1  e0b4  e0b5  e0cc  e0c0  e0d2  eoc6  e0c4  e0c8  e0b0  e0b1 
}

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  # if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
  #   print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  # else
  #   print -n "%{$bg%}%{$fg%}"
  # fi
  print -n " %{$bg%F{$DEFAULT_FG}%}$SEGMENT_SEPARATOR%{$fg%} "
  # print -n " $fg[gray]$SEGMENT_SEPARATOR$fg[default] "
  # print -n " %{$bg%}%{%F{$white}%}$SEGMENT_SEPARATOR%{$bg%}%{$fg%} "
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

prompt_begin() {
  echo -n "%{%k%F{$DEFAULT_FG}%}╭─┤ %{%k%f%}"
  if [[ $RETVAL -ne 0 ]]; then
    echo -n "%{%F{red}%}"
  else
    echo -n ""
  fi
  # echo -n "%{%k%F{white}%}╭─%{%k%F{gray}%}"
  CURRENT_BG='black'
}


# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$DEFAULT_FG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  # echo "%{%f%}"
  # printf "\x1b[38;2;255;0;0m└──\ue7b7\x1b[0m\n"
  # echo "%{%k%F{white}%}└──O)))%{%k%F{gray}%}"
  # echo "%{%k%f%}└───O)))%{%k%f%}"
  CURRENT_BG=''
}

rprompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  # if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
  #   print -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  # else
  #   print -n "%{$bg%}%{$fg%}"
  # fi
  print -n "%{$bg%F{$DEFAULT_FG}%}$R_SEGMENT_SEPARATOR%{$fg%} "
  # print -n " %{$bg%}%{%F{$white}%}$SEGMENT_SEPARATOR%{$bg%}%{$fg%} "
  CURRENT_BG=$1
  [[ -n $3 ]] && print -n $3
}

rprompt_begin() {
  echo -n "%{%k%f%}"
  # echo -n "%{%k%F{white}%}╭─%{%k%F{gray}%}"
  CURRENT_BG='black'
}

rprompt_long_task() {
  if (( $COLUMNS < 50 )); then return; fi
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    timer=""
    if (( $timer_show > ${REPORTTIME} )); then
      rprompt_segment bg yellow " ${timer_show}s "
    fi
  fi
}

# End the prompt, closing any open segments
rprompt_end() {
  # if [[ -n $CURRENT_BG ]]; then
  #   # echo -n " %{%k%F{CURRENT_BG}%}$SEGMENT_SEPARATOR"
  #   echo -n " %{%k%F{gray}%}$R_SEGMENT_SEPARATOR"
  # else
  #   echo -n "%{%k%}"
  # fi
  echo "%{%f%}"
  # printf "\x1b[38;2;255;0;0m└──\ue7b7\x1b[0m\n"
  # echo "%{%k%F{white}%}└──O)))%{%k%F{gray}%}"
  # echo "%{%k%f%}└───O)))%{%k%f%}"
  CURRENT_BG=''
}
### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
#   if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
# #    prompt_segment black default "%(!.%{%F{yellow}%}.)%n@%m"
#     prompt_segment black default "%(!.%{%F{yellow}%}.)%n"
#   fi
}

# Checks if working tree is dirty
parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain' '--ignore-submodules=dirty')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
    command git status ${FLAGS} 2> /dev/null | tail -n1
    echo $STATUS
  fi
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

# Git: branch/detached head, dirty status
prompt_git() {
  if (( $COLUMNS < 50 )) || (( $IS_INSIDE_GIT_WORK_TREE > 0 )); then return; fi
    # prompt_segment cgblack
    prompt_segment bg cyan
    PL_BRANCH_CHAR=""
    echo -n "${PL_BRANCH_CHAR} "
    CURRENT_BRANCH=$(git_current_branch)
    if (( ${#${CURRENT_BRANCH}} > 37 )); then
      CURRENT_BRANCH=$(echo $CURRENT_BRANCH | tail -c 35)
      CURRENT_BRANCH="..${CURRENT_BRANCH}"
    fi
    echo -n ${CURRENT_BRANCH}
    return
#### BELOW IS SLOWER VERSION WITH DIRTY STATUS
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue725'         # 
  }
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 2 ]]; then
    # prompt_segment cgblack
    prompt_segment bg cyan
    PL_BRANCH_EXCLAMATION_CHAR=$'\uf071'
    echo -n "${PL_BRANCH_CHAR}${PL_BRANCH_EXCLAMATION_CHAR} "
    CURRENT_BRANCH=$(git_current_branch)
    if (( ${#${CURRENT_BRANCH}} > 20 )); then
      CURRENT_BRANCH=$(echo $CURRENT_BRANCH | tail -c 18)
      CURRENT_BRANCH="..${CURRENT_BRANCH}"
    fi
    echo -n ${CURRENT_BRANCH}
    return
  fi
  local ref dirty mode repo_path

  # if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      if [[ ! -z $(git status --porcelain 2>/dev/null| grep "^??" ) ]]; then
        git_untracked=' '
        prompt_segment bg red
      else
        prompt_segment bg yellow
      fi
    else
      prompt_segment bg green
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '﯂'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}${git_untracked}"
  # fi
}

# Dir: current working directory
prompt_dir() {
  #prompt_segment blue $CURRENT_FG '%~'
  dir=$(print -Pr '%~')
  dir_length=${#${dir}}
  trimmed_dirname=$(print -Pr '%c')
  if (( $COLUMNS < 50 )); then
    if (( ${#${trimmed_dirname}} > 8 )); then
      trimmed_dirname=$(echo $trimmed_dirname | tail -c 8)
      prompt_segment bg magenta "..${trimmed_dirname}"
    else
      prompt_segment bg magenta "${trimmed_dirname}"
    fi
  else
    if (( $dir_length < 35 )) && (( $COLUMNS > 100 )); then
      prompt_segment bg magenta '%~'
    else
      trimmed_dirname=$(print -Pr '%~' | tail -c 33)
      prompt_segment bg magenta "..${trimmed_dirname}"
    fi
  fi
  # prompt_segment black red '%c'
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  if (( $COLUMNS < 100 )) || [[ ! -n $VIRTUAL_ENV ]]; then
    return
  else
    prompt_segment bg green " `basename $VIRTUAL_ENV`"
  fi
}

# Get openshift context; it's slow
get_openshift_project() {
  echo $(oc project -q | head -n 1)
}

# Openshift: current project and whether it match TILEER_NAMESPACE
prompt_openshift() {
  if [[ ! -n ${OPENSHIFT_CURRENT_PROJECT} ]] || (( $COLUMNS < 50 )); then return; fi
    local -a symbols
  if ${OC_REFRESH_NEEDED} ; then
    export OPENSHIFT_CURRENT_PROJECT=$(get_openshift_project)
  fi
  if [[ "${OPENSHIFT_CURRENT_PROJECT}" == "${TILLER_NAMESPACE}" ]]; then
    symbols+=" ${OPENSHIFT_CURRENT_PROJECT}"
    if (( $COLUMNS < 100 )) && (( ${#${OPENSHIFT_CURRENT_PROJECT}} > 20 )); then
      symbols=$(echo $symbols | tail -c 15)
      symbols=" ..$symbols"
    fi
    prompt_segment bg green $symbols
  else
    if (( $COLUMNS < 100 )); then
      symbols+=" "
    else
      symbols+="  ${OPENSHIFT_CURRENT_PROJECT} != ${TILLER_NAMESPACE}"
    fi
    prompt_segment bg red $symbols
  fi
}

# Status:
# - was there an error
prompt_status() {
  local -a symbols
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}$RETVAL"

  [[ -n "$symbols" ]] && prompt_segment bg red "$symbols"
}

rprompt_command_status() {
  local -a symbols
  if [[ $RETVAL -ne 0 ]]; then
    symbols+="%{%F{red}%} $RETVAL "
  else
    symbols+="%{%F{green}%} "
  fi

  [[ -n "$symbols" ]] && rprompt_segment bg red "$symbols"
}

rprompt_time() {
  if (( $COLUMNS < 75 )); then return; fi
  rprompt_segment bg default "%*"
}

prompt_status_background() {
  local -a symbols
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{magenta}%}"

  [[ -n "$symbols" ]] && prompt_segment default magenta "$symbols"
}

## Main prompt
build_prompt() {
  prompt_begin
  prompt_status
  prompt_status_background
  prompt_virtualenv
  prompt_openshift
  # prompt_aws
  # prompt_context
  prompt_dir
  prompt_git
  # prompt_bzr
  # prompt_hg
  prompt_end
}

build_rprompt() {
  rprompt_begin
  rprompt_long_task
  rprompt_command_status
  rprompt_time
  rprompt_end
}


preexec() {
  timer=$SECONDS
  if [[ "$1" == oc* ]]; then
    if [[ "$1" =~ 'oc project [^-]' ]] || [[ "$1" =~ 'oc login' ]]; then
      OC_REFRESH_NEEDED=true
    fi
    if [[ "$1" == "oc logout" ]]; then
      OC_REFRESH_NEEDED=false
      export OPENSHIFT_CURRENT_PROJECT=""
    fi
  fi
}

chpwd() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
  export IS_INSIDE_GIT_WORK_TREE=$?
}

periodic() {
  export CURR_DATE=$(date)
}

setopt PROMPT_SUBST
precmd() {
  RETVAL=$?
  if [[ $RETVAL != 0 ]]; then DEFAULT_FG="red"; else export DEFAULT_FG="default"; fi
  echo ""
  if $OC_REFRESH_NEEDED; then
    OPENSHIFT_CURRENT_PROJECT=$(get_openshift_project)
    export TILLER_NAMESPACE="$OPENSHIFT_CURRENT_PROJECT"
    OC_REFRESH_NEEDED=false
  fi
  local LEFT=$(build_prompt)
  # local RIGHT=$(build_rprompt)
  local RIGHT=""
  local zero='%([BSUbfksu]|([FK]|){*})'
  local LEFT_length=${#${(S%%)LEFT//$~zero/}}
  local RIGHT_length=${#${(S%%)RIGHT//$~zero/}}
  local num_filler_spaces=$(((COLUMNS - LEFT_length - RIGHT_length ) ))
  # print -Pr $LEFT${(l:$num_filler_spaces:: :)}$RIGHT
  # print -Pr "%{%k%F{$DEFAULT_FG}%}└───O)))%{%k%f%} $IS_INSIDE_GIT_WORK_TREE"
  # PS1="$LEFT${(l:$num_filler_spaces:: :)}$RIGHT"
  print -Pr $LEFT
  PS1="%{%k%F{$DEFAULT_FG}%}└───O)))%{%k%f%} "
}
