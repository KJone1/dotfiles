local themes = {
  {
    "sainnhe/gruvbox-material",
    lazy     = true,
    event    = "User ColorSchemeLoad",
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy     = true,
    event    = "User ColorSchemeLoad",
    priority = 1000,
  },
  {
    "EdenEast/nightfox.nvim",
    lazy     = false,
    event    = "User ColorSchemeLoad",
    priority = 1000,
    config   = function()
      require('nightfox').setup({
        options = {
          transparent = true
        }
      })
      vim.cmd.colorscheme("carbonfox")
    end
  },
  {
    "getomni/neovim",
    lazy     = true,
    event    = "User ColorSchemeLoad",
    priority = 1000,
  },
  {
    'olivercederborg/poimandres.nvim',
    lazy     = true,
    priority = 1000,
    event    = "User ColorSchemeLoad",
    -- config   = function()
    --   require('poimandres').setup {
    --     bold_vert_split          = true,  -- use bold vertical separators
    --     dim_nc_background        = true,  -- dim 'non-current' window backgrounds
    --     disable_background       = false, -- disable background
    --     disable_float_background = false, -- disable background for floats
    --     disable_italics          = false, -- disable italics
    --   }
    --   vim.cmd.colorscheme("poimandres")
    -- end,
  },
  {
    -- Default theme
    "Yazeed1s/oh-lucy.nvim",
    lazy     = true,
    event    = "User ColorSchemeLoad",
    priority = 1000,
  },
}

return themes

