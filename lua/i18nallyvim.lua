local yaml = require 'yaml'
local trim = require('utils').trim

local api = vim.api
local buf, win
local position = 0

local function center(str)
  local width = api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end

function getTranslationFile()
  return vim.g['i18nallyvim_file']
end

function exists(word)
  local translationFile = io.open(getTranslationFile(), "r")
  io.input(translationFile)
  local translations = translationFile:read('*all')
  io.close(translationFile)
  local parsedYaml = yaml.parse(translations)
  local currentWord = vim.api.nvim_eval('expand("<cword>")')
  if parsedYaml[currentWord] then
    return true
  end
  return false
end

local function show()
  local translationFile = io.open(getTranslationFile(), "r")
  io.input(translationFile)
  local translations = translationFile:read('*all')
  io.close(translationFile)
  local parsedYaml = yaml.parse(translations)
  local currentWord = vim.api.nvim_eval('expand("<cword>")')
  if parsedYaml[currentWord] then
    print(parsedYaml[currentWord])
    return;
  end
   print('does not exist translation for ' .. currentWord ..'!')
end

local function add()
  local currentWord = vim.api.nvim_eval('expand("<cword>")')
  if exists(currentWord) then
   print("There are already an translation for that word")
   return;
  end
  local translation = vim.api.nvim_eval("input('Translation: ')")
  local translationFile = io.open(getTranslationFile(), "a")
  io.output(translationFile)
  io.write("\n" .. currentWord .. ': ' .. translation)
  io.close(translationFile)
end


local function open_window()

  buf = api.nvim_create_buf(false, true)
  local border_buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'filetype', 'whid')

  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")

  local win_height = math.ceil(height * 0.8 - 4)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local border_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width + 2,
    height = win_height + 2,
    row = row - 1,
    col = col - 1
  }

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  local border_lines = { '╔' .. string.rep('═', win_width) .. '╗' }
  local middle_line = '║' .. string.rep(' ', win_width) .. '║'
  for i=1, win_height do
    table.insert(border_lines, middle_line)
  end
  table.insert(border_lines, '╚' .. string.rep('═', win_width) .. '╝')
  api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  local border_win = api.nvim_open_win(border_buf, true, border_opts)
  win = api.nvim_open_win(buf, true, opts)
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "'..border_buf)

  api.nvim_win_set_option(win, 'cursorline', true) -- it highlight line with the cursor on it

  -- we can add title already here, because first line will never change
  api.nvim_buf_set_lines(buf, 0, -1, false, { center('Select translation file1'), '', ''})
  api.nvim_buf_add_highlight(buf, -1, 'WhidHeader', 0, 0, -1)
end

local function move_cursor()
  local new_pos = math.max(4, api.nvim_win_get_cursor(win)[1] - 1)
  api.nvim_win_set_cursor(win, {new_pos, 0})
end

local function close_window()
  api.nvim_win_close(win, true)
end

local function set_mappings()
  local mappings = {
    ['<cr>'] = 'select_file()',
    j = 'update_view(-1)',
    k = 'update_view(1)',
    q = 'close_window()'
  }

  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require"i18nallyvim".'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end

  local other_chars = {
    'a', 'b', 'c', 'd', 'e', 'f', 'g', 'i', 'n', 'o', 'p', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
  }

  for k,v in ipairs(other_chars) do
    api.nvim_buf_set_keymap(buf, 'n', v, '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n', v:upper(), '', { nowait = true, noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, 'n',  '<c-'..v..'>', '', { nowait = true, noremap = true, silent = true })
  end
end



local function select_file()
  local path = api.nvim_get_current_line()
  close_window()
  local handle = io.popen("pwd")
  local currentDir = handle:read("*a")
  handle:close()
  local translation_file = trim(currentDir) .. "/" .. trim(path)
  api.nvim_set_var('i18nallyvim_file', translation_file)
end

local function load_translation_files(direction)
  api.nvim_buf_set_option(buf, 'modifiable', true)
  position = position + direction;
  if position < 0 then position = 0 end

  local result = vim.fn.systemlist('ack -f | ack \'/(.*).yaml\'')
  if #result == 0 then table.insert(result, '') end
  for k,v in pairs(result) do
    result[k] = '  '..result[k]
  end

  api.nvim_buf_set_lines(buf, 3, -1, false, result)

  api.nvim_buf_add_highlight(buf, -1, 'whidSubHeader', 1, 0, -1)
  api.nvim_buf_set_option(buf, 'modifiable', false)
end

local function check_for_translations_file()
  position = 0
  open_window()
  set_mappings()
  load_translation_files(0)
  api.nvim_win_set_cursor(win, {4, 0})
end

return {
  show = show,
  add = add,
  check_for_translations_file = check_for_translations_file,
  update_view = update_view,
  close_window = close_window,
  move_cursor = move_cursor,
  select_file = select_file
}
