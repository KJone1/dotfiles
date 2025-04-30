return {
  'leath-dub/snipe.nvim',
  lazy = true,
  opts = {
    sort = 'last',
    navigate = {
      close_buffer = 'dd',
    },
    hints = {
      dictionary = 'saflewcmpghio',
    },
    ui = {
      position = 'center',
      text_align = 'file-first',
      preselect_current = true,
      open_win_override = {
        border = 'rounded',
      },
    },
  },
}
