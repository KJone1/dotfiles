return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      enabled = true,
      sections = {
        { section = 'header' },
        { section = 'startup' },
      },
    },
    indent = {
      enabled = true,
      char = '▏',
      only_scope = false,
      scope = {
        enabled = true,
        char = '▏',
      },
      filter = function(buf)
        local filetype_excluded = vim.tbl_contains({
          '',
          'dashboard',
          'lspinfo',
          'packer',
          'checkhealth',
          'help',
          'man',
          'gitcommit',
          'TelescopePrompt',
          'TelescopeResults',
          'which_key',
        }, vim.bo[buf].filetype)
        local buftype_excluded = vim.bo[buf].buftype == 'nofile' or vim.bo[buf].buftype == 'prompt'
        return not (filetype_excluded or buftype_excluded)
      end,
    },
    lazygit = {
      enabled = true,
      configure = false,
    },
    styles = {
      lazygit = {
        width = 0.9,
        height = 0.9,
        border = 'rounded',
        wo = {
          winblend = 0,
        },
      },
    },
  },
}
