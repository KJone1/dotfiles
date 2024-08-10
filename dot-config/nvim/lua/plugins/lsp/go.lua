return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  ft = { 'go', 'gomod' },
  lazy = true,
  build = ':lua require("go.install").update_all_sync()',
  config = function()
    require('go').setup {
      goimports = 'gopls',
      gofmt = 'gopls',
      luasnip = true,
    }
  end,
}
