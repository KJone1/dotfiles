return {
  "okuuva/auto-save.nvim",
  cmd = "ASToggle", -- optional for lazy loading on command
  event = { "InsertLeave", "BufLeave", "FocusLost", "TextChanged" }, -- optional for lazy loading on trigger events 
  opts = {
    execution_message = {
      enabled = false,
    }
  },
}
