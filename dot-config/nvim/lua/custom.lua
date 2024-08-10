local M = {}

function M.ssr_line()

  local line = vim.api.nvim_get_current_line()

  if line ==  "" then
    vim.notify('Current line is blank', vim.log.levels.ERROR)
    return
  end

  local search = vim.fn.input("Search: ")

  if search == "" then
    return
  end

  local escaped_search = vim.fn.escape(search, '\\/.*$^~[]')

  if vim.fn.search(escaped_search, 'cn', line) ~= 0 then

    vim.cmd('highlight Search ctermbg=NONE ctermfg=lightmagenta guibg=lightmagenta guifg=black')

    local line_number = vim.fn.line('.')

    local pattern = '/\\%' .. line_number .. 'l' .. escaped_search .. '/'
    vim.cmd(string.format('match Search %s',pattern))
  else
    vim.notify(string.format('Pattern "%s" not found on this line',escaped_search), vim.log.levels.ERROR)
    return
  end

  local replace = vim.fn.input("Replace: ")
  if replace == "" then
    vim.cmd('highlight clear Search')
    vim.notify(string.format('Didnt replace "%s"',escaped_search), vim.log.levels.ERROR)
    return
  end
  vim.cmd('highlight clear Search')
  vim.cmd(string.format('s/%s/%s/g', escaped_search, replace))
end
function M.ssr_buffer()

  local search = vim.fn.input("Search: ")

  if search == "" then
    return
  end

  local escaped_search = vim.fn.escape(search, '\\/.*$^~[]')

  local matches = vim.fn.search(escaped_search)

  if matches == 0 then
    vim.notify(string.format('Pattern "%s" not found in buffer',escaped_search), vim.log.levels.ERROR)
    return
  end

  vim.cmd('highlight Search ctermbg=NONE ctermfg=lightmagenta guibg=lightmagenta guifg=black')
  vim.cmd('match Search /' .. escaped_search .. '/')

  local replace = vim.fn.input("Replace: ")
  if replace == "" then
    vim.cmd('highlight clear Search')
    vim.notify(string.format('Didnt replace "%s"',escaped_search), vim.log.levels.ERROR)
    return
  end
  vim.cmd('highlight clear Search')
  vim.cmd(string.format('%%s/%s/%s/g', escaped_search, replace))
end


function M.harpoon_component()

  local harpoon = require("harpoon.mark")

  local total_marks = harpoon.get_length()

  if total_marks == 0 then
    return ""
  end

  local current_mark = "—"

  local mark_idx = harpoon.get_current_index()
  if mark_idx ~= nil then
    current_mark = tostring(mark_idx)
  end

  return string.format("󱡅 %s/%d", current_mark, total_marks)
end

function M.current_file_component()

    local full_path = vim.fn.expand('%:p') -- Get the full path of the current file
    local components = vim.split(full_path, '/') -- Split the path into directory components

    local shortened = components[#components]  -- Last component (filename)
    if #components > 1 then
      shortened = components[#components - 1] .. '/' .. shortened -- Add the parent directory
    end

    return string.format(" %s",shortened)
end

return M

