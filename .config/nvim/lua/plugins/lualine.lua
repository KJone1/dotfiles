return {
    -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
   -- See `:help lualine.txt`
  opts = {
      options = {
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
          lualine_a = {
            { 'mode',right_padding = 2 },
          },
          lualine_b = {
            {'branch',color = { gui = 'bold' }},
            {'diff',
              symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
              diff_color = {
                added = { fg = '#98be65' },
                modified = { fg = '#FF8800' },
                removed = { fg = '#ec5f67' },
              },
            },
          },
          lualine_c = {
            {
              'diagnostics',
              source = { 'nvim' },
              sections = { 'error' },
              separator = { left = '|'},
              diagnostics_color = { error = { bg = '#ca1243', fg = '#f3f3f3' } },
            },
            {
              'diagnostics',
              source = { 'nvim' },
              sections = { 'warn' },
              separator = { left = ' '},
              diagnostics_color = { warn = { bg = '#fe8019', fg = '#f3f3f3' } },
            },
            {
              '%w',
              cond = function()
                return vim.wo.previewwindow
              end,
            },
            {
              '%r',
              cond = function()
                return vim.bo.readonly
              end,
            },
            {
              '%q',
              cond = function()
                return vim.bo.buftype == 'quickfix'
              end,
            },
          },
          lualine_x = {},
          lualine_y = {
            {'filetype'},
            {'encoding',fmt = string.upper,},
            {'fileformat',fmt = string.upper,icons_enabled = false,},
          },
          lualine_z = {},
      },
    },
  }

