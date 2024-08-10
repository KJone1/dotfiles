local SymbolKind = vim.lsp.protocol.SymbolKind

return {
  'VidocqH/lsp-lens.nvim',
  opts = {
    enable = true,
    include_declaration = false,
    sections = {
      definition = false,
      references = true,
      implements = true,
      git_authors = true,
    },
    ignore_filetype = {
      'prisma',
    },
    target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
    wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
    config = function(_, opts)
      require('lsp-lens').setup(opts)
    end,
  },
}
