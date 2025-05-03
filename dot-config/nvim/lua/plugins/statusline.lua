local M = {}

local default_color = 'DevIconImportConfiguration'
local error_color = 'DevIconNPMIgnore'
local warn_color = 'DevIconPreCommitConfig'
local added_color = 'DashboardCenter'
local modified_color = 'DevIconPreCommitConfig'
local removed_color = 'DevIconNPMIgnore'

local mode_map = {
  ['n'] = { text = 'NORMAL', color = 'MiniStatuslineModeNormal' },
  ['i'] = { text = 'INSERT', color = 'MiniStatuslineModeInsert' },
  ['v'] = { text = 'VISUAL', color = 'MiniStatuslineModeVisual' },
  ['V'] = { text = 'V-LINE', color = 'MiniStatuslineModeVisual' },
  ['\22'] = { text = 'V-BLOCK', color = 'MiniStatuslineModeVisual' }, -- '<C-v>' character
  ['R'] = { text = 'REPLACE', color = 'MiniStatuslineModeReplace' },
  ['t'] = { text = 'FzfLua', color = 'MiniStatuslineModeReplace' },
  ['c'] = { text = 'Command', color = 'DashboardCenter' },
}
local function hl(group, content)
  return string.format('%%#%s#%s%%*', group, content)
end
M.mode = function()
  local mode = vim.fn.mode()
  local mode_text = mode:sub(1, 1):upper() .. mode:sub(2):lower()
  local color = ''

  local mode_info = mode_map[mode]

  if mode_info then
    mode_text = mode_info.text
    color = mode_info.color
  else
    mode_text = mode_map['n'].text
    color = mode_map['n'].color
  end

  return hl(color, ' ' .. mode_text .. ' ')
end

M.diagnostics = function()
  local error_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warn_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local diag_status = ''
  if error_count > 0 then
    diag_status = diag_status .. hl(error_color, ' ' .. error_count) .. ' '
  end
  if warn_count > 0 then
    diag_status = diag_status .. hl(warn_color, ' ' .. warn_count) .. ' '
  end
  return diag_status
end

M.git_info = function()
  -- Use fallback because it doesn't set this variable on the initial `BufEnter`
  local signs = vim.b.gitsigns_status_dict or {}

  local added = tonumber(signs.added) or 0
  local changed = tonumber(signs.changed) or 0
  local removed = tonumber(signs.removed) or 0
  local head = signs.head or ''

  local is_head_empty = head ~= ''
  local signs_parts = {}

  if added > 0 or changed > 0 or removed > 0 then
    if added > 0 then
      table.insert(signs_parts, hl(added_color, ' ' .. added))
    end
    if changed > 0 then
      table.insert(signs_parts, hl(modified_color, ' ' .. changed))
    end
    if removed > 0 then
      table.insert(signs_parts, hl(removed_color, ' ' .. removed))
    end
  end

  return is_head_empty and string.format('  %s %s ', head, table.concat(signs_parts, ' ')) or ''
end
M.macro_recording = function()
  local recording_register = vim.fn.reg_recording()
  if recording_register ~= '' then
    recording_register = hl(error_color, recording_register)
    return '  Recording ' .. recording_register .. ' '
  else
    return ''
  end
end

M.current_file_component = function()
  if vim.fn.expand '%:t' == '' then
    return ''
  end

  local full_path = vim.fn.expand '%:p'
  local components = vim.split(full_path, '/')

  local shortened = components[#components]
  if #components > 1 then
    shortened = components[#components - 1] .. '/' .. shortened
  end

  local filename = string.format('󰝰 %s', shortened)

  return hl(default_color, filename .. ' ')
end

M.readonly_indicator = function()
  if vim.bo.readonly then
    return hl(default_color, '%r ') -- %r is a built-in statusline item for read-only
  else
    return ''
  end
end

M.preview_indicator = function()
  if vim.wo.previewwindow then
    return hl(default_color, '%w ') -- %w is a built-in statusline item for preview window
  else
    return ''
  end
end

M.quickfix_indicator = function()
  if vim.bo.buftype == 'quickfix' then
    return hl(default_color, '%q ') -- %q is a built-in statusline item for quickfix
  else
    return ''
  end
end

M.filetype = function()
  local file_name, file_ext = vim.fn.expand '%:t', vim.fn.expand '%:e'
  local icon = require('nvim-web-devicons').get_icon(file_name, file_ext, { default = true })
  local filetype = vim.bo.filetype

  if filetype == '' then
    return ''
  end

  icon = hl('DevIcon' .. file_ext, icon)
  return string.format(' %s %s ', icon, filetype)
end
M.fileformat = function()
  local fileformat = vim.bo.fileformat
  if fileformat == '' then
    return ''
  end
  return hl(default_color, string.upper(fileformat) .. ' ')
end
M.file_encoding = function()
  local file_encoding = vim.opt.fileencoding:get()

  local display_encoding
  if file_encoding == '' then
    -- If fileencoding is empty, use the value of the 'encoding' option.
    -- This is the internal encoding, often UTF-8.
    display_encoding = vim.opt.encoding:get()
  else
    display_encoding = file_encoding
  end

  return hl(default_color, string.upper(display_encoding) .. ' ')
end

M.active = function()
  local left_section = M.mode() .. M.git_info()
  local middle_section = M.macro_recording() .. M.current_file_component()
  local right_section = M.diagnostics()
    .. M.preview_indicator()
    .. M.readonly_indicator()
    .. M.quickfix_indicator()
    .. M.filetype()
    .. M.file_encoding()
    .. M.fileformat()

  -- Using %= to align sections
  return left_section .. '%=' .. middle_section .. '%=' .. right_section
end

local opts = {
  content = {
    active = M.active,
    inactive = nil,
  },
  use_icons = true,
}

return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
    require('mini.statusline').setup(opts)
  end,
}
