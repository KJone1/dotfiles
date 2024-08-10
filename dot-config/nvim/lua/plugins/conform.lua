return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  lazy = true,
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'isort', 'black' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },

    formatters = {
      shfmt = {
        prepend_args = { '-i', '2' },
      },
    },
  },
  init = function()
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
