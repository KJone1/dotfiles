return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('go').setup {
      goimports = 'gopls',
      gofmt = 'gopls',
      luasnip = true,
    }
  end,
  ft = { 'go', 'gomod' },
  lazy = true,
  build = ':lua require("go.install").update_all_sync()',
}
