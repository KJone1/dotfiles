return {
  'okuuva/auto-save.nvim',
  cmd = 'ASToggle',
  event = { 'InsertLeave', 'BufLeave', 'FocusLost' }, -- optional for lazy loading on trigger events
  opts = {
    write_all_buffers = true,
    execution_message = {
      enabled = false,
    },
  },
}
