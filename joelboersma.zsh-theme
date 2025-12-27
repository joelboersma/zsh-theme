# Based on built-in oh-my-zsh themes gallois, half-life, and arrow

# Depends on the git plugin for work_in_progress()
(( $+functions[work_in_progress] )) || work_in_progress() {}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg[yellow]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg[yellow]%}-%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg[yellow]%}+-%{$reset_color%}"

Customized git status, oh-my-zsh currently does not allow render dirty status before branch
git_custom_status() {
  local branch=$(git_current_branch)
  [[ -n "$branch" ]] || return 0
  echo "$(git_remote_status)$(parse_git_dirty)\
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
