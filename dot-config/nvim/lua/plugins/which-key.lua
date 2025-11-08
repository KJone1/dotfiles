return {
  'folke/which-key.nvim',
  lazy = false,
  priority = 1100,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local mappings = require 'keymaps'
    for _, contextMappings in pairs(mappings) do
      for mode, keymaps in pairs(contextMappings) do
        for _, keymap in ipairs(keymaps) do
          local key = keymap[1]
          local action = keymap[2]
          local opts = { desc = keymap.desc, silent = true }
          vim.keymap.set(mode, key, action, opts)
        end
      end
    end
  end,
  opts = {
    preset = 'modern',
    icons = {
      mappings = false,
    },
  },
}
