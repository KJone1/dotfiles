return {
  'folke/which-key.nvim',
  lazy = false,
  priority = 1100,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300

    local mappings = require 'keymaps'
    for mode, keymaps in pairs(mappings) do
      for _, keymap in ipairs(keymaps) do
        vim.keymap.set(mode, keymap[1], keymap[2], { desc = keymap.desc, silent = true })
      end
    end
  end,
  opts = {
    preset = 'classic',
    icons = {
      mappings = false,
    },
  },
}
