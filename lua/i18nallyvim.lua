local yaml = require 'yaml'

function exists(word)
  local translationFile = io.open("./example/pt_PT.yaml", "r")
  io.input(translationFile)
  local translations = io.read()
  io.close(translationFile)
  local parsedYaml = yaml.parse(translations)
  local currentWord = vim.api.nvim_eval('expand("<cword>")')
  if parsedYaml[currentWord] then
    return true
  end
  return false
end

local function show()
  local translationFile = io.open("./example/pt_PT.yaml", "r")
  io.input(translationFile)
  local translations = io.read()
  io.close(translationFile)
  local parsedYaml = yaml.parse(translations)
  local currentWord = vim.api.nvim_eval('expand("<cword>")')
  if parsedYaml[currentWord] then
    print(parsedYaml[currentWord])
  end
   print('does not exist!')
end

local function add()
  local currentWord = vim.api.nvim_eval('expand("<cword>")')
  if exists(currentWord) then
   print("There are already an translation for that word")
   return;
  end
  local translation = vim.api.nvim_eval("input('Translation: ')")
  local translationFile = io.open("./example/pt_PT.yaml", "a")
  io.output(translationFile)
  io.write(currentWord .. ': ' .. translation)
  io.close(translationFile)
end



return {
  show = show,
  add = add,
  exists = exists,
}
