# Tokyo Winter ZSH theme inspired by Tokyo Night (https://github.com/folke/tokyonight.nvim)"

PROMPT=$'%{%F{#c0caf5}%}[%{%B%F{#faf9f6}%}%~%{$reset_color%}%{%F{#c0caf5}%}]%{$(git_prompt_info)%}%(?,,%{%F{#c0caf5}%}[%{%B%F{#faf9f6}%}%?%{$reset_color%}%{%F{#c0caf5}%}]) %{$reset_color%} '
PS2=$' %{$fg[#c0caf5]%}|>%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{%F{#c0caf5}%}[%{%B%F{#faf9f6}%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{%F{#c0caf5}%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{%B%F{#faf9f6}%{$reset_color%}"
