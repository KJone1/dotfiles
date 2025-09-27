return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  cmd = 'FzfLua',
  config = function()
    local actions = require('fzf-lua').actions
    require('fzf-lua').setup {
      files = {
        previewer = false,
      },
      commands = {
        previewer = false,
        actions = {
          ['enter'] = actions.ex_run_cr,
        },
      },
      oldfiles = {
        previewer = false,
        cwd_only = true,
        include_current_session = true,
      },
      git = {
        status = {
          actions = false,
          previewer = false,
          cmd = 'git status -uall --porcelain | awk \'{s=substr($1,1,1); print (s=="M"?1:s=="A"?2:s=="D"?3:s=="?"?4:5), $0}\' | sort -n | cut -d\' \' -f2-',
        },
      },
    }
  end,
}
