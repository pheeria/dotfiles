# The git prompt's git commands are read-only and should not interfere with
# other processes. This environment variable is equivalent to running with `git
# --no-optional-locks`, but falls back gracefully for older versions of git.
# See git(1) for and git-status(1) for a description of that flag.
#
# We wrap in a local function instead of exporting the variable directly in
# order to avoid interfering with manually-run git commands by the user.
function __git_prompt_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

function git_prompt_info() {
  # If we are on a folder not tracked by git, get out.
  # Otherwise, check for hide-info at global and local repository level
  if ! __git_prompt_git rev-parse --git-dir &> /dev/null \
     || [[ "$(__git_prompt_git config --get oh-my-zsh.hide-info 2>/dev/null)" == 1 ]]; then
    return 0
  fi

  local ref
  ref=$(__git_prompt_git symbolic-ref --short HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git describe --tags --exact-match HEAD 2> /dev/null) \
  || ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) \
  || return 0

  # Use global ZSH_THEME_GIT_SHOW_UPSTREAM=1 for including upstream remote info
  local upstream
  if (( ${+ZSH_THEME_GIT_SHOW_UPSTREAM} )); then
    upstream=$(__git_prompt_git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>/dev/null) \
    && upstream=" -> ${upstream}"
  fi

  echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref:gs/%/%%}${upstream:gs/%/%%}$(parse_git_dirty)${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain')
  if [[ "$(__git_prompt_git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ "${DISABLE_UNTRACKED_FILES_DIRTY:-}" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    case "${GIT_STATUS_IGNORE_SUBMODULES:-}" in
      git)
        # let git decide (this respects per-repo config in .gitmodules)
        ;;
      *)
        # if unset: ignore dirty submodules
        # other values are passed to --ignore-submodules
        FLAGS+="--ignore-submodules=${GIT_STATUS_IGNORE_SUBMODULES:-dirty}"
        ;;
    esac
    STATUS=$(__git_prompt_git status ${FLAGS} 2> /dev/null | tail -n 1)
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
function git_current_branch() {
  local ref
  ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}


function git_prompt_status() {
  [[ "$(__git_prompt_git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]] && return

  # Maps a git status prefix to an internal constant
  # This cannot use the prompt constants, as they may be empty
  local -A prefix_constant_map
  prefix_constant_map=(
    '\?\? '     'UNTRACKED'
    'A  '       'ADDED'
    'M  '       'ADDED'
    'MM '       'MODIFIED'
    ' M '       'MODIFIED'
    'AM '       'MODIFIED'
    ' T '       'MODIFIED'
    'R  '       'RENAMED'
    ' D '       'DELETED'
    'D  '       'DELETED'
    'UU '       'UNMERGED'
    'ahead'     'AHEAD'
    'behind'    'BEHIND'
    'diverged'  'DIVERGED'
    'stashed'   'STASHED'
  )

  # Maps the internal constant to the prompt theme
  local -A constant_prompt_map
  constant_prompt_map=(
    'UNTRACKED' "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    'ADDED'     "$ZSH_THEME_GIT_PROMPT_ADDED"
    'MODIFIED'  "$ZSH_THEME_GIT_PROMPT_MODIFIED"
    'RENAMED'   "$ZSH_THEME_GIT_PROMPT_RENAMED"
    'DELETED'   "$ZSH_THEME_GIT_PROMPT_DELETED"
    'UNMERGED'  "$ZSH_THEME_GIT_PROMPT_UNMERGED"
    'AHEAD'     "$ZSH_THEME_GIT_PROMPT_AHEAD"
    'BEHIND'    "$ZSH_THEME_GIT_PROMPT_BEHIND"
    'DIVERGED'  "$ZSH_THEME_GIT_PROMPT_DIVERGED"
    'STASHED'   "$ZSH_THEME_GIT_PROMPT_STASHED"
  )

  # The order that the prompt displays should be added to the prompt
  local status_constants
  status_constants=(
    UNTRACKED ADDED MODIFIED RENAMED DELETED
    STASHED UNMERGED AHEAD BEHIND DIVERGED
  )

  local status_text
  status_text="$(__git_prompt_git status --porcelain -b 2> /dev/null)"

  # Don't continue on a catastrophic failure
  if [[ $? -eq 128 ]]; then
    return 1
  fi

  # A lookup table of each git status encountered
  local -A statuses_seen

  if __git_prompt_git rev-parse --verify refs/stash &>/dev/null; then
    statuses_seen[STASHED]=1
  fi

  local status_lines
  status_lines=("${(@f)${status_text}}")

  # If the tracking line exists, get and parse it
  if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]; then
    local branch_statuses
    branch_statuses=("${(@s/,/)match}")
    for branch_status in $branch_statuses; do
      if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]; then
        continue
      fi
      local last_parsed_status=$prefix_constant_map[$match[1]]
      statuses_seen[$last_parsed_status]=$match[2]
    done
  fi

  # For each status prefix, do a regex comparison
  for status_prefix in ${(k)prefix_constant_map}; do
    local status_constant="${prefix_constant_map[$status_prefix]}"
    local status_regex=$'(^|\n)'"$status_prefix"

    if [[ "$status_text" =~ $status_regex ]]; then
      statuses_seen[$status_constant]=1
    fi
  done

  # Display the seen statuses in the order specified
  local status_prompt
  for status_constant in $status_constants; do
    if (( ${+statuses_seen[$status_constant]} )); then
      local next_display=$constant_prompt_map[$status_constant]
      status_prompt="$next_display$status_prompt"
    fi
  done

  echo $status_prompt
}

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

alias gpsup='git push --set-upstream origin $(git_current_branch)'
alias gswm='git switch $(git_main_branch)'
