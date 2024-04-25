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
              symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
              color = {
                bg  = "NONE",
              },
              diff_color = {
                added    = { fg = '#98be65' },
                modified = { fg = '#FF8800' },
                removed  = { fg = '#ec5f67' },
              },
            },
          },
          lualine_c = {
          {
            'diagnostics',
            source            = { 'nvim' },
            sections          = { 'error' },
            color             = { bg  = "NONE" },
            separator         = { left = ' ' },
            diagnostics_color = { error = { bg = '#ca1243', fg = '#f3f3f3' } },
          },
          {
            'diagnostics',
            source            = { 'nvim' },
            sections          = { 'warn' },
            color             = { bg  = "NONE" },
            separator         = { left = ' '},
            diagnostics_color = { warn = { bg = '#fe8019', fg = '#f3f3f3' } },
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
          },
          lualine_x = {
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

