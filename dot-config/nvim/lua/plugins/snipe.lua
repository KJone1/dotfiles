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
      open_win_override = {
        border = 'rounded',
      },
    },
  },
}
