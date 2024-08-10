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
      python = { 'isort', 'black', stop_after_first = true },
      yaml = { 'yamlfmt', 'yamlfix', stop_after_first = true },
      sh = { 'shfmt', 'beautysh', stop_after_first = true },
      markdown = { 'mdformat' },
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
