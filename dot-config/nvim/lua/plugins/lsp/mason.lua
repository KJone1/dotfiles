return {
  'williamboman/mason.nvim',
  dependencies = {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },
  config = function()
    require('mason').setup {
      ui = {
        icons = {
          package_installed = '✓',
          package_pending = '➜',
          package_uninstalled = '✗',
        },
      },
    }
    -- You can add other tools here that you want Mason to install
    local ensure_installed = {
      'bash-language-server',
      'shellcheck',
      'shfmt',
      'black',
      'flake8',
      'debugpy',
      'clangd',
      'basedpyright',
      'clang-format',
      'codelldb',
      'dockerfile-language-server',
      'hadolint',
      'lua-language-server',
      'stylua',
      'prettier',
      'yamlfmt',
      'taplo',
    }
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }
  end,
}
