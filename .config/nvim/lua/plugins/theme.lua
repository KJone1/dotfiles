local themes = {
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    event = "User ColorSchemeLoad",
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    event = "User ColorSchemeLoad",
    priority = 1000,
  },
  {
    "getomni/neovim",
    as = "omni",
    lazy = true,
    event = "User ColorSchemeLoad",
    priority = 1000,
  },
  {
    -- Default theme
    "Yazeed1s/oh-lucy.nvim",
    lazy = false,
    event = "User ColorSchemeLoad",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("oh-lucy-evening")
    end,
  },
}

return themes

