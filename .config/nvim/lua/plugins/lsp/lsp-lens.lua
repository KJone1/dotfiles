return {
  "VidocqH/lsp-lens.nvim",
  opts = {
    enable = true,
    include_declaration = true,      -- Reference include declaration
    sections = {                      -- Enable / Disable specific request
      definition = false,
      references = true,
      implements = true,
    },
    ignore_filetype = {
      "prisma",
    },
  },
  config = function(_, opts)
    require'lsp-lens'.setup(opts)
  end
}
