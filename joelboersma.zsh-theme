# Based on built-in oh-my-zsh themes gallois, half-life, intheloop, and arrow

# Depends on the git plugin for work_in_progress()
(( $+functions[work_in_progress] )) || work_in_progress() {}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[yellow]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[yellow]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[yellow]%}↕%{$reset_color%}"

# Custom remote status that avoids oh-my-zsh's git_remote_status, which relies on
# hook_com[branch] (a vcs_info-only variable) and wc -l (whitespace-padded on macOS)
git_custom_remote_status() {
  local ahead behind
  ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
  behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

  [[ -n "$ahead" && -n "$behind" ]] || return

  if [[ $ahead -eq 0 && $behind -eq 0 ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE"
  elif [[ $ahead -gt 0 && $behind -eq 0 ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
  elif [[ $behind -gt 0 && $ahead -eq 0 ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
  elif [[ $ahead -gt 0 && $behind -gt 0 ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
  fi
}

# Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local branch=$(git_current_branch)
  [[ -n "$branch" ]] || return 0

  # Only parse the remote status if the current local branch has a remote counterpart
  local remote_status=""
  if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
    remote_status="$(git_custom_remote_status)"
  fi

  echo "${remote_status}$(parse_git_dirty)\
%{${fg_bold[yellow]}%}$(work_in_progress)%{$reset_color%}\
${ZSH_THEME_GIT_PROMPT_PREFIX}${branch}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

# Combine it all into a final right-side prompt
RPS1="\$(git_custom_status)${RPS1:+ $RPS1}"

# Use extended color palette for lambda if available
if [[ $TERM = (*256color|*rxvt*|*ghostty*) ]]; then
  lambda_orange="%{${(%):-"%F{166}"}%}"
  lambda_end="%{${(%):-"%f"}%}"
else
  lambda_orange="%{${(%):-"%{$fg[yellow]%}"}%}"
  lambda_end="%{${(%):-"%{$reset_color%}"}%}"
fi

PROMPT="${lambda_orange}λ${lambda_end} %{$fg[cyan]%}%1/%  %(?.%{$fg[green]%}.%{$fg[red]%})%B>>%b "
