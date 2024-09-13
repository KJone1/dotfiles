local DAP = {
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    config = function()
      require('dapui').setup()
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = {
      handlers = {},
    },
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'mfussenegger/nvim-dap-python',
    },
    config = function()
      require('dap-python').setup 'python'
    end,
  },
}

return DAP
