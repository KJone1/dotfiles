return {
  'declancm/cinnamon.nvim',
  config = function()
    require('cinnamon').setup {
      keymaps = {
        basic = true,
        extra = false,
      },
      options = {
        max_delta = {
          time = 1000,
        },
        mode = 'cursor',
      },
    }
  end,
}
