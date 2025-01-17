require 'options'
require 'custom'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  'tpope/vim-sleuth',
  { import = 'plugins' },
  { import = 'plugins.lsp' },
}
local opts = {
  ui = {
    custom_keys = {
      ['<leader>r'] = {
        function(_)
          ---@type LazyPlugin[]
          local plugin_list = require('lazy.core.config').plugins
          local file_content = {
            '## 💤 Plugin manager',
            '',
            '[lazy.nvim](https://github.com/folke/lazy.nvim)',
            '',
            '## 🔌 Plugins',
            '',
          }
          local plugins_md = {}
          for plugin, spec in pairs(plugin_list) do
            if spec.url then
              table.insert(plugins_md, ('- [%s](%s)'):format(plugin, spec.url:gsub('%.git$', '')))
            end
          end
          table.sort(plugins_md, function(a, b)
            return a:lower() < b:lower()
          end)

          for _, p in ipairs(plugins_md) do
            table.insert(file_content, p)
          end

          table.insert(file_content, '')

          local dotdir = os.getenv 'PWD'
          local file_path = dotdir .. '/dot-config/nvim/README.md'

          local file, err = io.open(file_path, 'w')
          if not file then
            error(err)
          end
          file:write(table.concat(file_content, '\n'))
          file:close()
          vim.notify('README.md succesfully generated', vim.log.levels.INFO, {})
        end,
        desc = 'Generate README.md file',
      },
    },
  },
}

require('lazy').setup(plugins, opts)

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
