# local time, color coded by last return code
time_prompt="%(?.%{$fg[green]%}.%{$fg[red]%})%*%{$reset_color%}"

# user part, color coded by privileges
local user="%(!.%{$fg[red]%}.%{$fg[blue]%})%n%{$reset_color%}"

local host=$(hostname -s)

# Compacted $PWD
#local pwd="%{$fg[blue]%}%w%{$reset_color%}"

function build_ps1() {
local WS=""
local pwd=""
if [[ $PWD =~ "/google/src/cloud/.*/google3*" ]]; then
   WS="$FG[076][ ${PWD[(ws:/:)5]} ] "
   pwd="google3${PWD#*google3}"
else
   pwd="%~"
fi
echo "${WS}${pwd} "
}

PROMPT='${time_prompt} ${user}@${host} $(build_ps1)$(git_prompt_info)$FG[105]%(!.#.»)%{$reset_color%} '

# i would prefer 1 icon that shows the "most drastic" deviation from HEAD,
# but lets see how this works out
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%} %{$fg[yellow]%}?%{$fg[green]%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# elaborate exitcode on the right when >0
return_code_enabled="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
return_code_disabled=
return_code=$return_code_enabled

RPS1='${return_code}'

function accept-line-or-clear-warning () {
	if [[ -z $BUFFER ]]; then
		time=$time_disabled
		return_code=$return_code_disabled
	else
		time=$time_enabled
		return_code=$return_code_enabled
	fi
	zle accept-line
}
zle -N accept-line-or-clear-warning
bindkey '^M' accept-line-or-clear-warning
