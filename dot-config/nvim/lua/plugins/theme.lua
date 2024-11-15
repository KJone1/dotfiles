local themes = {
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    event = 'User ColorSchemeLoad',
    priority = 1000,
    config = function()
      require('nightfox').setup {
        options = {
          transparent = true,
        },
      }
      vim.cmd.colorscheme 'carbonfox'
    end,
  },
}

return themes
