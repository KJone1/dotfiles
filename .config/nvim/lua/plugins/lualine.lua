return {
  'nvim-lualine/lualine.nvim',
  opts = {
      options = {
        icons_enabled = true,
        component_separators = '',
        section_separators = ' ',
      },
      sections = {
          lualine_a = {
            { 'mode',right_padding = 2 },
          },
          lualine_b = {
            {
              require("custom").current_file_component,
              color = {
                bg  = "NONE",
              }
            },
            {
              'branch',
              color = {
                bg  = "NONE",
              }
            },
            {
              'diff',
              symbols = { added = ' ', modified = ' ', removed = ' ' },
              color = {
                bg  = "NONE",
              },
              diff_color = {
                added    = { fg = '#98be65' },
                modified = { fg = '#FF8800' },
                removed  = { fg = '#ca1243' },
              },
            },
          },
          lualine_c = {},
          lualine_x = {
            {
              'diagnostics',
              source            = { 'nvim' },
              sections          = { 'error' },
              separator         = { left = ' ' },
              diagnostics_color = { error = { bg = 'NONE', fg = '#ca1243' } },
            },
            {
              'diagnostics',
              source            = { 'nvim' },
              sections          = { 'warn' },
              separator         = { left = ' '},
              diagnostics_color = { warn = { bg = 'NONE', fg = '#FF8800' } },
            },
            {
              '%w',
              color = { bg  = "NONE" },
              cond  = function()
                return vim.wo.previewwindow
              end,
            },
            {
              '%r',
              color = { bg  = "NONE" },
              cond  = function()
                return vim.bo.readonly
              end,
            },
            {
              '%q',
              color = { bg  = "NONE" },
              cond  = function()
                return vim.bo.buftype == 'quickfix'
              end,
            },
            {
              require("custom").harpoon_component,
              color = {
                bg = "NONE",
                fg = "white"
              }
            }
          },
          lualine_y = {
            {
              'filetype',
              icons_enabled = false,
              color = {
                bg = "NONE",
              }
            },
            {
              'encoding',
              fmt = string.upper,
              color = {
                bg = "NONE",
              }
            },
            {
              'fileformat',
              fmt = string.upper,icons_enabled = false,
              color = {
                bg = "NONE",
              }
            }
          },
          lualine_z = {},
      },
    },
  }

