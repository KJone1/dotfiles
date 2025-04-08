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
    }
  end,
}
