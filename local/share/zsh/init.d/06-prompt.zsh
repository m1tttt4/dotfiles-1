_prompt_char='»'
_prompt_host="%m"
_prompt_user="%n"

_prompt_status() {
  if [[ $? -eq 0 ]]; then
    printf " %%F{green}%s%%f" "${_prompt_char}"
  else
    printf " %%F{red}%s%%f" "${_prompt_char}"
  fi
}

_git_prompt_abbrev() {
  git rev-parse --abbrev-ref HEAD
}

_git_prompt_stash() {
  [[ -n "$(git stash list)" ]] && return 0 || return 1
}

_git_prompt_modified() {
  git diff --no-ext-diff --quiet --exit-code && return 1 || return 0
}

_prompt_git() {
  if ! git rev-parse --git-dir --quiet &> /dev/null; then
    return
  fi

  local mods
  set -A mods
  if _git_prompt_modified; then
    mods+=("!")
  fi

  if _git_prompt_stash; then
    mods+=("$")
  fi

  local modified=""
  if [[ ${#mods[@]} -gt 0 ]]; then
    local symbols
    printf -v symbols "%s" "${mods[@]}"
    modified=" [%F{red}${symbols}%f]"
  fi

  printf " on %s%s" \
    "%F{magenta} $(_git_prompt_abbrev)%f" \
    "${modified}"
}

# Note: all prompt components are responsible for their own left space padding if applicable
export PROMPT='${_prompt_user}@%F{yellow}${_prompt_host}%f$(_prompt_git)$(_prompt_status) '

# vim: set filetype=zsh