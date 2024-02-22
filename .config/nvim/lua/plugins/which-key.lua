return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {},
  config = function()
      local wk = require("which-key")
      local mappings = require("mappings") -- Ensure this matches the file name of your mappings

      -- local setupMappings = function()
      --   for mode, mapping in pairs(mappings.general) do
      --     wk.register(mapping, { mode = mode })
      --   end
      -- end

      local setupMappings = function()
          for _, contextMappings in pairs(mappings) do
              for mode, mapping in pairs(contextMappings) do
                  wk.register(mapping, { mode = mode })
              end
          end
      end

      setupMappings()
  end
}
