return{
   'lukas-reineke/indent-blankline.nvim',
   -- See `:help indent_blankline.txt`
   main = "ibl",
   opts = {
      indent = {
         char = "▏",
         smart_indent_cap = false
      },
      whitespace = { highlight = { "Whitespace", "NonText" } },
      exclude = {
         filetypes = {
           "lspinfo",
           "packer",
           "checkhealth",
           "help",
           "man",
           "gitcommit",
           "TelescopePrompt",
           "TelescopeResults",
           "''",
           "dashboard"
         }
      }
   },
}
