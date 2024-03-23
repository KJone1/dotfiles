local M = {}

function M.ssr()

  local search = vim.fn.input("Search: ")

  if search == "" then
    return
  end

  local line = vim.api.nvim_get_current_line()

  if vim.fn.search(search, 'cn', line) ~= 0 then

    vim.cmd('highlight Search ctermbg=NONE ctermfg=lightmagenta guibg=lightmagenta guifg=black')

    local line_number = vim.fn.line('.')
    local escaped_search = vim.fn.escape(search, '\\/.*$^~[]')

    local pattern = '/\\%' .. line_number .. 'l' .. escaped_search .. '/'
    vim.cmd(string.format('match Search %s',pattern))
  else
    vim.notify(string.format('Pattern "%s" not found on this line',search), vim.log.levels.ERROR)
    return
  end

  local replace = vim.fn.input("Replace: ")
  if replace == "" then
    vim.cmd('highlight clear Search')
    return
  end
  vim.cmd('highlight clear Search')
  vim.cmd(string.format('s/%s/%s/g', search, replace))
end
function M.ssr_all()

  local search = vim.fn.input("Search: ")

  if search == "" then
    return
  end

  local escaped_search = vim.fn.escape(search, '\\/.*$^~[]')

  local matches = vim.fn.search(escaped_search)

  if matches == 0 then
    vim.notify(string.format('Pattern "%s" not found in buffer',search), vim.log.levels.ERROR)
    return
  end

  vim.cmd('highlight Search ctermbg=NONE ctermfg=lightmagenta guibg=lightmagenta guifg=black')
  vim.cmd('match Search /' .. escaped_search .. '/')

  local replace = vim.fn.input("Replace: ")
  if replace == "" then
    vim.cmd('highlight clear Search')
    return
  end
  vim.cmd('highlight clear Search')
  vim.cmd(string.format('%%s/%s/%s/g', escaped_search, replace))
end

return M

