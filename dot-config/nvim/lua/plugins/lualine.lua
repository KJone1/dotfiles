local default_color = { fg = 'white', bg = 'NONE' }
local error_color = { fg = '#ca1243', bg = 'NONE' }
local warn_color = { fg = '#FF8800', bg = 'NONE' }
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
        { 'mode', right_padding = 2 },
      },
      lualine_b = {
        {
          'branch',
          color = default_color,
        },
        {
          'diff',
          symbols = { added = ' ', modified = ' ', removed = ' ' },
          color = default_color,
          diff_color = {
            added = { fg = '#98be65' },
            modified = warn_color,
            removed = error_color,
          },
        },
      },
      lualine_c = {},
      lualine_x = {
        {
          'diagnostics',
          source = { 'nvim' },
          sections = { 'error' },
          separator = { left = ' ' },
          diagnostics_color = { error = error_color },
        },
        {
          'diagnostics',
          source = { 'nvim' },
          sections = { 'warn' },
          separator = { left = ' ' },
          diagnostics_color = { warn = warn_color },
        },
        {
          '%w',
          color = default_color,
          cond = function()
            return vim.wo.previewwindow
          end,
        },
        {
          '%r',
          color = default_color,
          cond = function()
            return vim.bo.readonly
          end,
        },
        {
          '%q',
          color = default_color,
          cond = function()
            return vim.bo.buftype == 'quickfix'
          end,
        },
        {
          require('custom').harpoon_component,
          color = default_color,
        },
      },
      lualine_y = {
        {
          require('custom').current_file_component,
          color = default_color,
        },
        {
          'filetype',
          fmt = string.upper,
          color = default_color,
        },
        {
          'fileformat',
          fmt = string.upper,
          icons_enabled = false,
          color = default_color,
        },
      },
      lualine_z = {},
    },
  },
}
